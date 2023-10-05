import 'dart:io';

import 'package:collection/collection.dart';
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/appwrite/appwrite_platform.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteLocalOpsEnvironment with IsOpsEnvironment {
  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      return false;
    }

    if (!await _hasAppwriteContainer(context)) {
      return false;
    }

    if (!await _hasAppwriteCli(context)) {
      return false;
    }

    return true;
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    if (!await _hasAppwriteCli(context)) {
      await _installAppwriteCli(context);
    }

    await _installConfigFiles(context);

    await context.coreProject.run(
      'docker compose up -d --remove-orphans',
      workingDirectory: context.coreDirectory / 'appwrite',
    );
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    await context.appwriteOutputDirectory.ensureCreated();

    final projectId = await _getProjectId(context, environmentType: environmentType);

    await context.appwriteTerminal.run('appwrite login', interactable: true);

    await _updatePlatforms(context, projectId: projectId);

    await DataSource.static.directory(context.appwriteOutputDirectory).delete();
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    await context.appwriteTerminal.run('docker compose stop');
  }

  Future<void> _installConfigFiles(AutomateCommandContext context) async {
    final appwriteDockerComposeFile = context.coreDirectory / 'appwrite' - 'docker-compose.yml';
    final appwriteDockerComposeDataSource =
        DataSource.static.url(Uri.parse('https://appwrite.io/install/compose')).mapResponseBody();
    await DataSource.static.file(appwriteDockerComposeFile).set(await appwriteDockerComposeDataSource.get());

    final appwriteEnvFile = context.coreDirectory / 'appwrite' - '.env';
    final appwriteEnvDataSource = DataSource.static.url(Uri.parse('https://appwrite.io/install/env')).mapResponseBody();
    await DataSource.static.file(appwriteEnvFile).set(await appwriteEnvDataSource.get());
  }

  Future<bool> _isDockerInstalled(AutomateCommandContext context) async {
    try {
      await context.coreProject.run('docker version');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _hasAppwriteContainer(AutomateCommandContext context) async {
    final output = await context.coreProject.run('docker ps -f name=appwrite');
    return output.contains('appwrite');
  }

  Future<bool> _hasAppwriteCli(AutomateCommandContext context) async {
    try {
      await context.coreProject.run('appwrite -v');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _installAppwriteCli(AutomateCommandContext context) async {
    await context.coreProject.run('npm install -g appwrite-cli');
    if (!await _hasAppwriteCli(context)) {
      throw Exception('Could not install appwrite cli!');
    }
  }

  Future<String> _getProjectId(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return await context.getHiddenStateOrElse(
      'appwrite/${environmentType.name}/projectId',
      () => context.input(
          'Input your Appwrite Project ID. To do this, access Appwrite at http://localhost/, then sign in, then create a project, then go to the project settings, and paste in the Project ID.'),
    );
  }

  Future<List<AppwritePlatform>> _getPlatforms(AutomateCommandContext context, {required String projectId}) async {
    final output = await context.appwriteTerminal.run('appwrite projects listPlatforms --projectId $projectId');

    return output
        .split('\n')
        .where((line) => line.contains('│'))
        .skip(1)
        .map((line) => line.withoutAnsiEscapeCodes)
        .map((line) {
      final values = line.split('│').map((e) => e.trim()).toList();
      return AppwritePlatform(
        id: values[0],
        name: values[3],
        type: values[4],
        key: values[5],
      );
    }).toList();
  }

  Future<void> _updatePlatforms(AutomateCommandContext context, {required String projectId}) async {
    final desiredKeyByType = {
      'flutter-android': await context.getAndroidIdentifier(),
      'flutter-ios': await context.getIosIdentifier(),
      'flutter-web': 'localhost',
    };
    final existingPlatforms = await _getPlatforms(context, projectId: projectId);

    for (final (type, key) in desiredKeyByType.entryRecords) {
      if (existingPlatforms.none((platform) => type == platform.type && key == platform.key)) {
        await context.appwriteTerminal
            .run('appwrite projects createPlatform --projectId $projectId --type $type --name $key --key $key');
      }
    }
  }
}

extension on AutomateCommandContext {
  Directory get appwriteOutputDirectory => coreDirectory / 'appwrite' / 'output';

  Terminal get appwriteTerminal => terminal.withWorkingDirectory(appwriteOutputDirectory);
}

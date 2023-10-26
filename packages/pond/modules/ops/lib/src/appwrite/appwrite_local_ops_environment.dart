import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart' hide Permission;
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/appwrite/appwrite_ops_utils.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteLocalOpsEnvironment with IsOpsEnvironment {
  final File Function(Directory coreDirectory)? serverFileTemplateGetter;
  final List<Pattern> ignoreBackendPatterns;

  AppwriteLocalOpsEnvironment({
    this.serverFileTemplateGetter,
    this.ignoreBackendPatterns = const [],
  });

  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      return false;
    }

    if (!await _hasAppwriteContainer(context)) {
      return false;
    }

    if (!await AppwriteOpsUtils.hasAppwriteCli(context)) {
      return false;
    }

    return true;
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    if (!await AppwriteOpsUtils.hasAppwriteCli(context)) {
      await AppwriteOpsUtils.installAppwriteCli(context);
    }

    if (!await _hasConfigFiles(context)) {
      await _installConfigFiles(context);
    }

    await context.confirmAndExecutePlan(Plan.run(
      'docker compose up -d --remove-orphans',
      workingDirectory: context.appwriteDirectory,
    ));
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    await context.appwriteOutputDirectory.ensureCreated();

    final projectId = await AppwriteOpsUtils.getProjectId(
      context,
      environmentType: environmentType,
      locationDescription: 'Appwrite at http://localhost',
    );
    final apiKey = await AppwriteOpsUtils.getApiKey(context, environmentType: environmentType);

    final client = Client(endPoint: 'https://localhost/v1', selfSigned: true).setProject(projectId).setKey(apiKey);

    await context.appwriteTerminal.run('appwrite client --endpoint http://localhost/v1');
    // await context.appwriteTerminal.run('appwrite login', interactable: true);

    // await AppwriteOpsUtils.updatePlatforms(context, projectId: projectId, webDomain: 'localhost');
    // await AppwriteOpsUtils.updateAppwriteAttributes(context, client: client);

    final serverFileTemplate = serverFileTemplateGetter?.call(context.coreDirectory);
    if (serverFileTemplate != null) {
      await AppwriteOpsUtils.deployFunctions(
        context,
        client: client,
        functionTemplate: serverFileTemplate,
        ignorePatterns: ignoreBackendPatterns,
      );
    }
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    await context.confirmAndExecutePlan(Plan.run('docker compose stop', workingDirectory: context.appwriteDirectory));
  }

  Future<bool> _hasConfigFiles(AutomateCommandContext context) async {
    return await DataSource.static.file(context.coreDirectory / 'appwrite' - 'docker-compose.yml').exists() &&
        await DataSource.static.file(context.coreDirectory / 'appwrite' - '.env').exists();
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
}

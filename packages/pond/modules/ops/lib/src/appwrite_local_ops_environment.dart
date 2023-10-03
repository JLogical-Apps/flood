import 'package:environment_core/environment_core.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:path_core/path_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:task_core/task_core.dart';
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
    final outputDirectory = context.coreDirectory / 'tool' / 'output';

    final projectId = await _getProjectId(context, environmentType: environmentType);
    final apiKey = await _getApiKey(context, environmentType: environmentType);

    await context.run(
      'appwrite client --endpoint http://localhost/v1 --projectId $projectId --key $apiKey',
      workingDirectory: outputDirectory,
    );

    final tasks = [
      Task(name: 'find-project', runner: (Route route) => route.pathDefinition),
    ];

    for (final task in tasks) {
      await context.run('echo ${task.name}');
    }

    await DataSource.static.directory(outputDirectory).delete();
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    await context.coreProject.run(
      'docker compose stop',
      workingDirectory: context.fileSystem.coreDirectory / 'appwrite',
    );
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

  Future<String> _getApiKey(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return await context.getHiddenStateOrElse(
      'appwrite/${environmentType.name}/apiKey',
      () => context.input(
          'Input your Appwrite API Key. To do this, go to your project settings, View API keys, create an API key, give it access to all scopes, then paste in the API Key Secret.'),
    );
  }
}

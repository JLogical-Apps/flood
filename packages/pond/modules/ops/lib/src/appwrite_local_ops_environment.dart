import 'package:environment_core/environment_core.dart';
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

    final output = await context.coreProject.run('docker ps -f name=appwrite');
    return output.contains('appwrite');
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    await _installConfigFiles(context);

    await context.coreProject.run(
      'docker compose up -d --remove-orphans',
      workingDirectory: context.coreDirectory / 'appwrite',
    );
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    throw UnimplementedError('Deploy is not implemented!');
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
}

import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart' hide Permission;
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/appwrite/appwrite_ops_utils.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteOpsEnvironment with IsOpsEnvironment {
  final File Function(Directory coreDirectory)? serverFileTemplateGetter;

  AppwriteOpsEnvironment({this.serverFileTemplateGetter});

  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return true;
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await AppwriteOpsUtils.hasAppwriteCli(context)) {
      await AppwriteOpsUtils.installAppwriteCli(context);
    }

    await context.appwriteOutputDirectory.ensureCreated();

    final projectId = await AppwriteOpsUtils.getProjectId(
      context,
      environmentType: environmentType,
      locationDescription: 'Appwrite Cloud',
    );
    final apiKey = await AppwriteOpsUtils.getApiKey(context, environmentType: environmentType);
    final webDomain = await _getWebDomain(context, environmentType: environmentType);

    final client = Client(endPoint: 'https://cloud.appwrite.io/v1').setProject(projectId).setKey(apiKey);

    await context.appwriteTerminal.run('appwrite client --endpoint https://cloud.appwrite.io/v1');
    await context.appwriteTerminal.run('appwrite login', interactable: true);

    await AppwriteOpsUtils.updatePlatforms(context, projectId: projectId, webDomain: webDomain);
    await AppwriteOpsUtils.updateAppwriteAttributes(context, client: client);
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    throw Exception('Cannot delete a cloud environment!');
  }

  Future<String> _getWebDomain(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return await context.getStateOrElse(
      'appwrite/${environmentType.name}/webDomain',
      () => context.input('Input your Flutter web domain.'),
    );
  }
}

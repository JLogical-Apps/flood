import 'dart:io';

import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseOpsUtils {
  static Future<bool> setupFirebase(AutomateCommandContext context) async {
    await context.firebaseDirectory.ensureCreated();

    try {
      await context.run('firebase --version');
    } catch (e) {
      final shouldInstallFirebase =
          context.confirm('Firebase is not installed on this machine. Would you like to install it?');
      if (!shouldInstallFirebase) {
        context.error('Firebase needs to be installed.');
        return false;
      }

      try {
        await context.run('npm install -g firebase-tools');
      } catch (e) {
        context.error(
            'Unable to install Firebase. Follow `https://firebase.google.com/docs/cli` to install Firebase manually.');
        return false;
      }
    }

    try {
      await context.run('firebase login --interactive', interactable: true);
    } catch (e) {
      return false;
    }

    return true;
  }

  static Future<String> getOrCreateFirebaseProjectId(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final firebaseSourceFile = context.firebaseDirectory - 'firebase.json';
    if (!await firebaseSourceFile.exists()) {
      await initFirebase(context, environmentType: environmentType);

      if (!await firebaseSourceFile.exists()) {
        throw Exception('Unable to initialize Firebase project!');
      }
    }

    final projectId = await getEnvironmentProjectIdOrNull(context, environmentType: environmentType);
    if (projectId != null) {
      return projectId;
    }

    final shouldAdd = context.confirm(
        "There isn't a Firebase project configured with the ${environmentType.name} environment. Would you like to set one up?");
    if (!shouldAdd) {
      throw Exception('No Firebase projecet configured with the ${environmentType.name} environment.');
    }

    await context.run(
      'firebase use --add',
      workingDirectory: context.firebaseDirectory,
      interactable: true,
    );

    final currentlyUsedProjectId = await getCurrentlyUsedProjectId(context);
    await updateEnvironmentProject(context, environmentType: environmentType, projectId: currentlyUsedProjectId);
    return currentlyUsedProjectId;
  }

  static Future<String?> initFirebase(AutomateCommandContext context,
      {required EnvironmentType environmentType}) async {
    final shouldInit =
        context.confirm('A firebase project has not been initialized. Would you like to initialize one?');
    if (!shouldInit) {
      throw Exception('No Firebase project initialized!');
    }

    await context.run(
      'firebase init',
      workingDirectory: context.firebaseDirectory,
      interactable: true,
    );

    final projectId = await getCurrentlyUsedProjectId(context);
    await updateEnvironmentProject(context, environmentType: environmentType, projectId: projectId);
    return projectId;
  }

  static Future<String?> getCurrentlyUsedProjectIdOrNull(AutomateCommandContext context) async {
    final output = await context.run(
      'firebase use',
      workingDirectory: context.firebaseDirectory,
    );
    return output.nullIfBlank;
  }

  static Future<String> getCurrentlyUsedProjectId(AutomateCommandContext context) async {
    return await getCurrentlyUsedProjectIdOrNull(context) ??
        (throw Exception('Unable to get currently used Firebase Project ID'));
  }

  static Future<String?> getEnvironmentProjectIdOrNull(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final stateFileDataSource = DataSource.static.file(context.stateFile).mapYaml();
    final state = await stateFileDataSource.getOrNull() ?? <String, dynamic>{};
    state.ensureNested(['firebase', environmentType.name]);
    return state['firebase'][environmentType.name]['project_id'];
  }

  static Future<void> updateEnvironmentProject(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
    required String projectId,
  }) async {
    final stateFileDataSource = DataSource.static.file(context.stateFile).mapYaml();
    await stateFileDataSource.update((state) {
      state = (state ?? {}).copy()..ensureNested(['firebase', environmentType.name]);
      state['firebase'][environmentType.name]['project_id'] = projectId;
      return state;
    });
  }
}

extension AutomateCommandContextExtensions on AutomateCommandContext {
  Directory get firebaseDirectory => getRootDirectory() / 'firebase';
}

import 'dart:io';

import 'package:environment_core/environment_core.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseEmulatorOpsEnvironment with IsOpsEnvironment {
  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    try {
      final projectId = await _getEnvironmentProjectIdOrNull(context, environmentType: environmentType);
      if (projectId == null) {
        return false;
      }

      final emulatorOutput = await context.run('lsof -i :9099');
      return emulatorOutput.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _setupFirebase(context)) {
      throw Exception('Unable to setup Firebase!');
    }

    final projectId = await _getOrCreateFirebaseProjectId(context, environmentType: environmentType);
    await context.run(
      'firebase use $projectId',
      workingDirectory: context.firebaseDirectory,
    );

    await context.run(
      'firebase emulators:start',
      workingDirectory: context.firebaseDirectory,
    );
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    throw UnimplementedError('Delete not implemented.');
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    final projectId = await _getEnvironmentProjectIdOrNull(context, environmentType: environmentType);
    context.print('project id: $projectId');
  }

  Future<bool> _setupFirebase(AutomateCommandContext context) async {
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

  Future<String> _getOrCreateFirebaseProjectId(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final firebaseSourceFile = context.firebaseDirectory - 'firebase.json';
    if (!await firebaseSourceFile.exists()) {
      await _initFirebase(context, environmentType: environmentType);

      if (!await firebaseSourceFile.exists()) {
        throw Exception('Unable to initialize Firebase project!');
      }
    }

    final projectId = await _getEnvironmentProjectIdOrNull(context, environmentType: environmentType);
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

    final currentlyUsedProjectId = await _getCurrentlyUsedProjectId(context);
    await _updateEnvironmentProject(context, environmentType: environmentType, projectId: currentlyUsedProjectId);
    return currentlyUsedProjectId;
  }

  Future<String?> _initFirebase(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
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

    final projectId = await _getCurrentlyUsedProjectId(context);
    await _updateEnvironmentProject(context, environmentType: environmentType, projectId: projectId);
    return projectId;
  }

  Future<String?> _getCurrentlyUsedProjectIdOrNull(AutomateCommandContext context) async {
    final output = await context.run(
      'firebase use',
      workingDirectory: context.firebaseDirectory,
    );
    return output.nullIfBlank;
  }

  Future<String> _getCurrentlyUsedProjectId(AutomateCommandContext context) async {
    return await _getCurrentlyUsedProjectIdOrNull(context) ??
        (throw Exception('Unable to get currently used Firebase Project ID'));
  }

  Future<String?> _getEnvironmentProjectIdOrNull(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final stateFileDataSource = DataSource.static.file(context.stateFile).mapYaml();
    final state = await stateFileDataSource.getOrNull() ?? <String, dynamic>{};
    state.ensureNested(['firebase', environmentType.name]);
    return state['firebase'][environmentType.name]['project_id'];
  }

  Future<void> _updateEnvironmentProject(
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

extension _AutomateCommandContextExtensions on AutomateCommandContext {
  Directory get firebaseDirectory => getRootDirectory() / 'firebase';
}

import 'package:environment_core/environment_core.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseEmulatorOpsEnvironment with IsOpsEnvironment {
  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    try {
      final output = await context.run('lsof -i :9099');
      return output.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _setupFirebase(context)) {
      throw Exception('Unable to setup Firebase!');
    }

    final firebaseDirectory = context.getRootDirectory() / 'firebase';
    final projectId = await _getFirebaseProjectId(context, environmentType: environmentType);
    await context.run(
      'firebase use $projectId',
      workingDirectory: firebaseDirectory,
    );

    await context.run(
      'firebase emulators:start',
      workingDirectory: firebaseDirectory,
    );
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    throw UnimplementedError('Delete not implemented.');
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    final stateFileDataSource = DataSource.static.file(context.stateFile).mapYaml();
    final state = await stateFileDataSource.getOrNull() ?? {};
    context.print('project id: ${state['firebase'][environmentType.name]['project_id']}');
  }

  Future<bool> _setupFirebase(AutomateCommandContext context) async {
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

  Future<String> _getFirebaseProjectId(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final firebaseDirectory = context.getRootDirectory() / 'firebase';
    final firebaseSourceFile = firebaseDirectory - 'firebase.json';
    if (!await firebaseSourceFile.exists()) {
      final shouldInit =
          context.confirm('A firebase project has not been initialized. Would you like to initialize one?');
      if (!shouldInit) {
        throw Exception('No Firebase project initialized!');
      }

      await firebaseDirectory.ensureCreated();
      await context.run(
        'firebase init',
        workingDirectory: firebaseDirectory,
        interactable: true,
      );

      if (!await firebaseSourceFile.exists()) {
        throw Exception('Unable to initialize Firebase project!');
      }

      final projectId = await _getCurrentlyUsedProjectId(context);

      final stateFileDataSource = DataSource.static.file(context.stateFile).mapYaml();
      await stateFileDataSource.update((state) {
        state = (state ?? {}).copy()..ensureNested(['firebase', environmentType.name, 'project_id']);
        state['firebase'][environmentType.name]['project_id'] = projectId;
        return state;
      });
      return projectId;
    }

    return await _getCurrentlyUsedProjectId(context);
  }

  Future<String> _getCurrentlyUsedProjectId(AutomateCommandContext context) async {
    final firebaseDirectory = context.getRootDirectory() / 'firebase';

    final output = await context.run(
      'firebase use',
      workingDirectory: firebaseDirectory,
    );
    return output;
  }
}

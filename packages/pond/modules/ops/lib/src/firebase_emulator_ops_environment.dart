import 'package:environment_core/environment_core.dart';
import 'package:ops/src/firebase_ops_utils.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseEmulatorOpsEnvironment with IsOpsEnvironment {
  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    try {
      final projectId = await FirebaseOpsUtils.getEnvironmentProjectIdOrNull(context, environmentType: environmentType);
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
    if (!await FirebaseOpsUtils.setupFirebase(context)) {
      throw Exception('Unable to setup Firebase!');
    }

    final projectId = await FirebaseOpsUtils.getOrCreateFirebaseProjectId(context, environmentType: environmentType);
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
    final firestoreRules = FirebaseOpsUtils.generateFirestoreRules(context.automateContext.corePondContext);
    await DataSource.static.file(context.firebaseDirectory - 'firestore.rules').set(firestoreRules);
  }
}

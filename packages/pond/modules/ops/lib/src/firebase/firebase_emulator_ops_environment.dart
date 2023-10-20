import 'package:environment_core/environment_core.dart';
import 'package:firebase_ops/firebase_ops.dart';
import 'package:ops/src/firebase/firebase_security_rules_generator.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseEmulatorOpsEnvironment with IsOpsEnvironment {
  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    await FirebaseOpsUtils.ensureFirebaseInitialized(context);
    final projectId = await FirebaseOpsUtils.getProjectIdOrNull(context, environmentType: environmentType);
    if (projectId == null) {
      return false;
    }

    final emulatorOutput = await guardAsync(() => context.coreProject.run('lsof -i :9099'));
    return emulatorOutput != null && emulatorOutput.isNotEmpty;
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    await FirebaseOpsUtils.useProjectId(context, environmentType: environmentType);
    await context.coreProject.run(
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
    await FirebaseOpsUtils.useProjectId(context, environmentType: environmentType);

    final firestoreRulesFile = context.firebaseDirectory - 'firestore.rules';
    final firestoreRulesSource = DataSource.static.file(firestoreRulesFile);
    final oldFirestoreRules = (await firestoreRulesSource.getOrNull()) ?? '';

    final firestoreRules =
        FirebaseSecurityRulesGenerator().generateFirestoreRules(context.automateContext.corePondContext);
    await firestoreRulesSource.set(firestoreRules);

    await context.confirmAndExecutePlan(Plan([
      PlanItem.static.diff(previousValue: oldFirestoreRules, file: firestoreRulesFile),
      PlanItem.static.run(
        'firebase deploy --only firestore:rules',
        workingDirectory: context.firebaseDirectory,
      ),
    ]));
  }
}

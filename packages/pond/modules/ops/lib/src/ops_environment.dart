import 'package:ops/src/appwrite_local_ops_environment.dart';
import 'package:ops/src/firebase_emulator_ops_environment.dart';
import 'package:pond_cli/pond_cli.dart';

abstract class OpsEnvironment {
  Future<bool> exists(AutomateCommandContext context);

  Future<void> onCreate(AutomateCommandContext context);

  Future<void> onDeploy(AutomateCommandContext context);

  Future<void> onDelete(AutomateCommandContext context);

  static OpsEnvironmentStatic get static => OpsEnvironmentStatic();
}

class OpsEnvironmentStatic {
  AppwriteLocalOpsEnvironment get appwriteLocal => AppwriteLocalOpsEnvironment();

  FirebaseEmulatorOpsEnvironment get firebaseEmulators => FirebaseEmulatorOpsEnvironment();
}

extension OpsEnvironmentExtensions on OpsEnvironment {
  Future<void> create(AutomateCommandContext context) {
    return onCreate(context);
  }

  Future<void> deploy(AutomateCommandContext context) {
    return onDeploy(context);
  }

  Future<void> delete(AutomateCommandContext context) {
    return onDelete(context);
  }
}

mixin IsOpsEnvironment implements OpsEnvironment {}

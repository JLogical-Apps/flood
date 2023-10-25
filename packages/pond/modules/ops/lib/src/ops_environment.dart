import 'dart:io';

import 'package:environment_core/environment_core.dart';
import 'package:ops/src/appwrite/appwrite_local_ops_environment.dart';
import 'package:ops/src/appwrite/appwrite_ops_environment.dart';
import 'package:ops/src/firebase/firebase_emulator_ops_environment.dart';
import 'package:ops/src/firebase/firebase_ops_environment.dart';
import 'package:pond_cli/pond_cli.dart';

abstract class OpsEnvironment {
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType});

  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType});

  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType});

  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType});

  static OpsEnvironmentStatic get static => OpsEnvironmentStatic();
}

class OpsEnvironmentStatic {
  AppwriteLocalOpsEnvironment appwriteLocal({File Function(Directory coreDirectory)? serverFileTemplateGetter}) =>
      AppwriteLocalOpsEnvironment(serverFileTemplateGetter: serverFileTemplateGetter);

  AppwriteOpsEnvironment appwrite({File Function(Directory coreDirectory)? serverFileTemplateGetter}) =>
      AppwriteOpsEnvironment(serverFileTemplateGetter: serverFileTemplateGetter);

  FirebaseEmulatorOpsEnvironment get firebaseEmulator => FirebaseEmulatorOpsEnvironment();

  FirebaseOpsEnvironment get firebase => FirebaseOpsEnvironment();
}

extension OpsEnvironmentExtensions on OpsEnvironment {
  Future<void> create(AutomateCommandContext context, {required EnvironmentType environmentType}) {
    return onCreate(context, environmentType: environmentType);
  }

  Future<void> deploy(AutomateCommandContext context, {required EnvironmentType environmentType}) {
    return onDeploy(context, environmentType: environmentType);
  }

  Future<void> delete(AutomateCommandContext context, {required EnvironmentType environmentType}) {
    return onDelete(context, environmentType: environmentType);
  }
}

mixin IsOpsEnvironment implements OpsEnvironment {
  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {}
}

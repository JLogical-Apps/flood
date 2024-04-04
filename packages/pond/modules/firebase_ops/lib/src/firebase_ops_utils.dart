import 'dart:io';

import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseOpsUtils {
  FirebaseOpsUtils._();

  static Future<void> ensureFirebaseInitialized(AutomateCommandContext context) async {
    await context.firebaseDirectory.ensureCreated();
    await _ensureFirebaseCliInstalled(context);
    await context.firebaseTerminal.run('firebase login --interactive', interactable: true);
    await _initFirebaseFiles(context);
  }

  static Future<String?> getProjectIdOrNull(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final firebaseRc = await context.firebaseRcDataSource.get();
    final projects = firebaseRc['projects'] as Map<String, dynamic>;
    return projects[environmentType.name];
  }

  static Future<String> useProjectId(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
  }) async {
    final firebaseRc = await context.firebaseRcDataSource.get();
    final projects = firebaseRc['projects'] as Map<String, dynamic>;

    final projectId = projects[environmentType.name];
    if (projectId != null) {
      await context.firebaseTerminal.run('firebase use $projectId');
      return projectId;
    }

    await context.firebaseTerminal.run(
      'firebase use --add',
      interactable: true,
    );

    final newProjectId = await _getCurrentlyUsedProjectId(context);
    projects[environmentType.name] = newProjectId;
    await context.firebaseRcDataSource.set(firebaseRc.copy()..set('projects', projects));

    return newProjectId;
  }

  static Future<void> _ensureFirebaseCliInstalled(AutomateCommandContext context) async {
    try {
      await context.coreProject.run('firebase --version');
    } catch (e) {
      await context.confirmAndExecutePlan(Plan.run(
        name: 'Install Firebase CLI',
        'npm install -g firebase-tools',
        workingDirectory: context.firebaseDirectory,
      ));
    }
  }

  static Future<void> _initFirebaseFiles(AutomateCommandContext context) async {
    final firebaseSourceFile = context.firebaseDirectory - 'firebase.json';
    if (await firebaseSourceFile.exists()) {
      return;
    }

    await context.confirmAndExecutePlan(Plan.run(
      'firebase init',
      workingDirectory: context.firebaseDirectory,
    ));

    if (await firebaseSourceFile.exists()) {
      throw Exception('Unable to create Firebase files!');
    }
  }

  static Future<String?> _getCurrentlyUsedProjectIdOrNull(AutomateCommandContext context) async {
    final output = await context.firebaseTerminal.run('firebase use');
    return output.nullIfBlank;
  }

  static Future<String> _getCurrentlyUsedProjectId(AutomateCommandContext context) async {
    return await _getCurrentlyUsedProjectIdOrNull(context) ??
        (throw Exception('Unable to get currently used Firebase Project ID'));
  }
}

extension AutomateCommandContextExtensions on AutomateCommandContext {
  Directory get firebaseDirectory => coreDirectory / 'firebase';

  DataSource<Map<String, dynamic>> get firebaseRcDataSource =>
      DataSource.static.file(firebaseDirectory - '.firebaserc').mapJson();

  Terminal get firebaseTerminal => terminal.withWorkingDirectory(firebaseDirectory);
}

import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/utils.dart';

class FirebaseAutomationModule extends AutomationModule {
  @override
  String get name => 'Firebase';

  final Directory firebaseDirectory;

  FirebaseAutomationModule({Directory? firebaseDirectory})
      : this.firebaseDirectory =
            firebaseDirectory ?? Directory.current / 'firebase' {
    registerAutomation(
      name: 'emulators',
      description: 'Starts up the emulators.',
      action: _setupEmulators,
    );
    registerAutomation(
      name: 'deploy',
      description: 'Deploys the local changes to Firebase.',
      action: _deploy,
    );
  }

  Future<void> _setupEmulators(AutomationContext context) async {
    await _setupFirebase(context);
    await context.run('firebase emulators:start');
  }

  Future<void> _deploy(AutomationContext context) async {
    await _setupFirebase(context);
  }

  Future<void> _setupFirebase(AutomationContext context) async {
    await context.run('cd ${firebaseDirectory.relativePath}');

    try {
      await context.run('firebase --version');
    } catch (e) {
      final shouldInstallFirebase = context.confirm(
          'Firebase is not installed on this machine. Would you like to install it?');
      if (!shouldInstallFirebase) {
        context.error('Firebase needs to be installed.');
        return;
      }

      try {
        await context.run('npm install -g firebase-tools');
      } catch (e) {
        context.error(
            'Unable to install Firebase. Follow `https://firebase.google.com/docs/cli` to install Firebase manually.');
        return;
      }
    }

    await context.run('firebase login --interactive');
  }
}

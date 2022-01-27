import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/utils.dart';

class FirebaseAutomationModule extends AutomationModule {
  @override
  String get name => 'Firebase';

  final Directory firebaseDirectory;

  FirebaseAutomationModule({Directory? firebaseDirectory})
      : this.firebaseDirectory = firebaseDirectory ?? Directory.current / 'firebase' {
    registerAutomation(
      name: 'init',
      description: 'Initializes Firebase for this project.',
      action: _initFirebase,
    );
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

  Future<void> _initFirebase(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return;
    }

    await firebaseDirectory.ensureCreated();
    final firebaseJsonFile = firebaseDirectory - 'firebase.json';
    if (!await firebaseJsonFile.exists()) {
      context.print(
          'You need to initialize firebase! Run this command to initialize from the terminal:\ncd firebase\nfirebase init');
    }
  }

  Future<void> _setupEmulators(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return;
    }

    await context.run('firebase emulators:start');
  }

  Future<void> _deploy(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return;
    }
  }

  Future<bool> _setupFirebase(AutomationContext context) async {
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
      await context.run('firebase login --interactive');
    } catch (e) {
      return false;
    }

    return true;
  }
}

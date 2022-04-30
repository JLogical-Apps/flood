import 'dart:io';

import 'package:jlogical_utils/src/pond/automation_modules/environment/environment_listening_automation_module.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../automation/automation_context.dart';
import '../../automation/automation_module.dart';
import '../../automation/automations_provider.dart';
import '../../modules/environment/environment.dart';

class FirebaseAutomationModule extends AutomationModule implements EnvironmentListeningAutomationModule {
  @override
  String get name => 'Firebase';

  @override
  List<Command> get commands => [
        SimpleCommand(
          name: 'init',
          displayName: 'Initialize',
          description: 'Initializes Firebase for this project.',
          category: 'Firebase',
          runner: (args) async {
            await _initFirebase();
          },
        ),
        SimpleCommand(
          name: 'register',
          displayName: 'Register Project',
          description: 'Registers a Firebase Project to this project.',
          category: 'Firebase',
          parameters: {
            'project-id': CommandParameter.string(
              displayName: 'Project ID',
              description: 'The project id to register.',
            ),
            'env': CommandParameter.string(
              displayName: 'Environment',
              description: 'The environments to associate the project with.', // TODO multiple.
            ),
          },
          runner: (args) async {
            await _registerProject();
          },
        ),
        SimpleCommand(
          name: 'emulators',
          displayName: 'Start Emulators',
          description: 'Opens up the emulators.',
          category: 'Firebase',
          runner: (args) async {
            await _setupEmulators();
          },
        ),
      ];

  final Directory firebaseDirectory;

  FirebaseAutomationModule({Directory? firebaseDirectory})
      : this.firebaseDirectory = firebaseDirectory ?? Directory.current / 'firebase';

  @override
  Future<void> onEnvironmentChanged(
    Environment? oldEnvironment,
    Environment newEnvironment,
  ) async {
    if (newEnvironment == Environment.qa) {
      await _setupEmulators();
    }
  }

  Future<bool> _initFirebase() async {
    if (!await _setupFirebase()) {
      return false;
    }

    await firebaseDirectory.ensureCreated();
    final firebaseJsonFile = firebaseDirectory - 'firebase.json';
    if (!await firebaseJsonFile.exists()) {
      await context.run('firebase init', workingDirectory: firebaseDirectory);

      if (!await firebaseJsonFile.exists()) {
        throw Exception('Cannot find firebase json file!');
      }
    }

    return true;
  }

  Future<void> _registerProject() async {
    if (!await _initFirebase()) {
      return;
    }

    String? projectId = context.args['project-id'];
    if (projectId == null) {
      await context.run('firebase projects:list');
      projectId = context
          .input(
              'Above are the projects associated with your account. Type in the id of the project you want to register:\n')
          .nullIfBlank;
    }
    if (projectId == null) {
      context.error('A project id is needed to register a Firebase project!');
      return;
    }

    final environments = await context.getEnvironments(
      selectPrompt:
          'Which environments would you like to associate the Firebase project with? Any environments that already exist will be overwritten by selecting them here.',
    );

    if (environments.isEmpty) {
      context.error('At least one environment is needed to map to in order to register a Firebase project!');
      return;
    }

    final config = (await context.getConfig()) ?? {};
    config.ensureNested(['firebase', 'environments']);
    environments.forEach((environment) => config['firebase']['environments'][environment.name] = projectId);

    await context.saveConfig(config);

    context.run('firebase use --add', workingDirectory: firebaseDirectory);
  }

  Future<void> _setupEmulators() async {
    if (!await _setupFirebase()) {
      return;
    }

    await context.run('firebase emulators:start', workingDirectory: firebaseDirectory);
  }

  Future<bool> _setupFirebase() async {
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

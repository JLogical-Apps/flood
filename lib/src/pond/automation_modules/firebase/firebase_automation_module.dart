import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/pond/automation_modules/environment/environment_listening_automation_module.dart';
import 'package:jlogical_utils/utils.dart';

import '../../modules/environment/environment.dart';

class FirebaseAutomationModule extends AutomationModule implements EnvironmentListeningAutomationModule {
  @override
  String get name => 'Firebase';

  final Directory firebaseDirectory;

  FirebaseAutomationModule({Directory? firebaseDirectory})
      : this.firebaseDirectory = firebaseDirectory ?? Directory.current / 'firebase' {
    final firebaseCommand = registerAutomation(name: 'firebase', description: 'Commands relating to Firebase.');
    firebaseCommand.registerAutomation(
      name: 'init',
      description: 'Initializes Firebase for this project.',
      action: _initFirebase,
    );
    firebaseCommand.registerAutomation(
        name: 'register',
        description: 'Registers a Firebase Project to this project.',
        action: _registerProject,
        args: (args) {
          args.addOption(
            'project-id',
            help: 'The project id to register.',
          );
          args.addMultiOption(
            'environments',
            aliases: ['envs'],
            help: 'The environments to associate the project with.',
            allowed: Environment.values.map((env) => env.name).toList(),
          );
        });
    firebaseCommand.registerAutomation(
      name: 'emulators',
      description: 'Starts up the emulators.',
      action: _setupEmulators,
    );
    firebaseCommand.registerAutomation(
        name: 'refresh',
        description: "Refreshes the project's indices and security rules from the live version.",
        action: _refresh,
        args: (args) {
          args.addOption(
            'environment',
            aliases: ['env'],
            help: 'The environment whose project to refresh the indices from.',
            allowed: Environment.values.map((env) => env.name).toList(),
            defaultsTo: Environment.production.name,
          );
        });
    firebaseCommand.registerAutomation(
      name: 'deploy',
      description: 'Deploys the local changes to Firebase.',
      args: (args) {
        args.addMultiOption(
          'environments',
          aliases: ['envs'],
          help: 'The environments whose Firebase projects to deploy.',
          allowed: Environment.values.map((env) => env.name).toList(),
        );
        args.addMultiOption(
          'project-ids',
          help: 'The ids of the Firebase projects to deploy.',
        );
        args.addFlag(
          'all',
          abbr: 'a',
          negatable: false,
          help: 'Whether to deploy all registered Firebase projects.',
        );
      },
      action: _deploy,
    );
  }

  @override
  Future<void> onEnvironmentChanged(
    AutomationContext context,
    Environment? oldEnvironment,
    Environment newEnvironment,
  ) async {
    if (newEnvironment == Environment.qa) {
      await _setupEmulators(context);
    }
  }

  Future<bool> _initFirebase(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return false;
    }

    await firebaseDirectory.ensureCreated();
    final firebaseJsonFile = firebaseDirectory - 'firebase.json';
    if (!await firebaseJsonFile.exists()) {
      context.print(
          'You need to initialize firebase! Run this command to initialize from the terminal:\ncd ${firebaseDirectory.relativePath}\nfirebase init');
      return false;
    }

    return true;
  }

  Future<void> _registerProject(AutomationContext context) async {
    if (!await _initFirebase(context)) {
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

    context.print(
        'Run this command to actually register the project to Firebase:\ncd ${firebaseDirectory.relativePath}\nfirebase use --add');
  }

  Future<void> _refresh(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return;
    }

    final env = await context.getEnvironmentOrNull() ?? (throw Exception('Environment needed to refresh from!'));
    final projectId = await _getProjectIdFromEnvironmentName(context, envName: env.name);
    if (projectId == null) {
      context.error('No project found associated with $env environment!');
      return;
    }

    context.print(
        'Run this command to save the indexes and rules:\ncd ${firebaseDirectory.relativePath}\nfirebase firestore:indexes --project $projectId > firestore.indexes.json');
    context.print(
        'You will need to manually copy/paste the firestore/storage rules since there is no way to do that from the CLI :-(');
  }

  Future<void> _setupEmulators(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return;
    }

    await context.run('firebase emulators:start', workingDirectory: firebaseDirectory);
  }

  Future<void> _deploy(AutomationContext context) async {
    if (!await _initFirebase(context)) {
      return;
    }

    List<String> projectIds = [];
    List<String> projectIdsArg = context.args['project-ids'];
    projectIds = projectIdsArg;

    if (projectIds.isEmpty && context.args['all']) {
      final config = (await context.getConfig()) ?? {};
      config.ensureNested(['firebase', 'environments']);

      projectIds = config['firebase']['environments'].values.cast<String>().toSet().toList();
    }

    if (projectIds.isEmpty) {
      List<Environment> environments = await context.getEnvironments(
        selectPrompt: 'Select which associated environments you would like to deploy!',
      );
      if (environments.isNotEmpty) {
        final config = (await context.getConfig()) ?? {};
        config.ensureNested(['firebase', 'environments']);

        projectIds = environments
            .where((env) => config['firebase']['environments'][env] != null)
            .map((env) => config['firebase']['environments'][env] as String)
            .toSet()
            .toList();
      }
    }

    if (projectIds.isEmpty) {
      context.error('No projects to deploy! Specify some using the arguments!');
      return;
    }

    await Future.wait(projectIds.map((id) => context.run(
          'firebase deploy --project=$id',
          workingDirectory: firebaseDirectory,
        )));
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

  Future<String?> _getProjectIdFromEnvironmentName(AutomationContext context, {required String envName}) async {
    final config = (await context.getConfig()) ?? {};
    config.ensureNested(['firebase', 'environments']);

    return config['firebase']['environments'][envName];
  }
}

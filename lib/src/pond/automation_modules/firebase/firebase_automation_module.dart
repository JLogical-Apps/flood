import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
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
        name: 'register_project',
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
    registerAutomation(
      name: 'emulators',
      description: 'Starts up the emulators.',
      action: _setupEmulators,
    );
    registerAutomation(
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

  Future<bool> _initFirebase(AutomationContext context) async {
    if (!await _setupFirebase(context)) {
      return false;
    }

    await firebaseDirectory.ensureCreated();
    final firebaseJsonFile = firebaseDirectory - 'firebase.json';
    if (!await firebaseJsonFile.exists()) {
      context.print(
          'You need to initialize firebase! Run this command to initialize from the terminal:\ncd firebase\nfirebase init');
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
              'Above are the projects associated with your account. Type in the id of the project you want to register.')
          .nullIfBlank;
    }
    if (projectId == null) {
      context.error('A project id is needed to register a Firebase project!');
      return;
    }

    List<String> environmentNames = context.args['environments'];
    var environments =
        environmentNames.map((name) => Environment.values.firstWhere((env) => env.name == name)).toList();

    if (environments.isEmpty) {
      environments = context.multiSelect(
        prompt:
            'Which environments would you like to associate the Firebase project with? Any environments that already exist will be overwritten by selecting them here.',
        options: Environment.values,
        stringMapper: (env) => env.name,
      );
    }
    if (environments.isEmpty) {
      context.error('At least one environment is needed to map to in order to register a Firebase project!');
      return;
    }

    final config = (await _getConfigData()) ?? {};
    config.ensureNested(['firebase', 'environments']);
    environments.forEach((environment) => config['firebase']['environments'][environment.name] = projectId);

    await _saveConfigData(config);
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

    if (projectIds.isEmpty) {
      List<String> environmentsNames = context.args['environments'];
      if (environmentsNames.isNotEmpty) {
        final config = (await _getConfigData()) ?? {};
        config.ensureNested(['firebase', 'environments']);

        projectIds = environmentsNames
            .where((env) => config['firebase']['environments'][env] != null)
            .map((env) => config['firebase']['environments'][env] as String)
            .toSet()
            .toList();
      }
    }

    if (projectIds.isEmpty && context.args['all']) {
      final config = (await _getConfigData()) ?? {};
      config.ensureNested(['firebase', 'environments']);

      projectIds = config['firebase']['environments'].values.cast<String>().toSet().toList();
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

  DataSource<Map<String, dynamic>> _configDataSource() {
    return FileDataSource(file: Directory.current / 'assets' - 'config.yaml').mapYaml();
  }

  Future<Map<String, dynamic>?> _getConfigData() async {
    return await _configDataSource().getData();
  }

  Future<void> _saveConfigData(Map<String, dynamic> data) async {
    await _configDataSource().saveData(data);
  }
}

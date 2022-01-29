import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:jlogical_utils/src/pond/automation/package_registration.dart';
import 'package:jlogical_utils/src/pond/automation/with_console_automation_output.dart';
import 'package:jlogical_utils/src/pond/automation/with_pubspec_package_registration.dart';
import 'package:jlogical_utils/src/pond/automation/with_shell_automation_interactor.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

import 'automation.dart';

class AutomationContext
    with WithConsoleAutomationOutput, WithShellAutomationInteractor, WithPubspecPackageRegistration
    implements AutomationInteractor, PackageRegistration {
  late ArgResults args;

  List<AutomationModule> modules = [];

  List<Automation> get automations => modules.expand((element) => element.automations).toList();

  void registerModule(AutomationModule module) {
    modules.add(module);
  }

  Future<Environment?> getEnvironmentOrNull({
    String? argName: 'environment',
    bool shouldAskIfNoArg: true,
    String selectPrompt: 'Select environment:',
  }) async {
    Environment? environment;
    if (argName != null && args.options.contains(argName)) {
      final environmentArgName = args[argName];
      environment = _environmentFromNameOrNull(environmentArgName) ??
          (throw Exception('Environment [$environmentArgName] not recognized!'));
    }

    if (environment == null) {
      Environment? configEnvironment;
      final config = (await getConfig() ?? {});
      final environmentConfigName = config['environment'];
      if (environmentConfigName != null) {
        configEnvironment = Environment.values.firstWhereOrNull((env) => env.name == environmentConfigName) ??
            (throw Exception('Environment [$environmentConfigName] not recognized!'));
      }

      if (shouldAskIfNoArg) {
        environment = select<Environment>(
          prompt: selectPrompt,
          options: Environment.values,
          stringMapper: (env) => env.name,
        );
      } else {
        environment = configEnvironment;
      }
    }

    return environment;
  }

  Future<List<Environment>> getEnvironments({
    String? argName: 'environments',
    bool shouldAskIfNoArgs: true,
    String selectPrompt: 'Select environments:',
  }) async {
    List<Environment> environments = [];
    if (argName != null && args.options.contains(argName)) {
      List<String> environmentArgNames = args[argName];
      environments = environmentArgNames
          .map((envName) =>
              _environmentFromNameOrNull(envName) ?? (throw Exception('Environment [$envName] not recognized!')))
          .toList();
    }

    if (environments.isEmpty) {
      Environment? configEnvironment;
      final config = (await getConfig() ?? {});
      final environmentConfigName = config['environment'];
      if (environmentConfigName != null) {
        configEnvironment = Environment.values.firstWhereOrNull((env) => env.name == environmentConfigName) ??
            (throw Exception('Environment [$environmentConfigName] not recognized!'));
      }

      if (shouldAskIfNoArgs) {
        environments = multiSelect<Environment>(
          prompt: selectPrompt,
          options: Environment.values,
          stringMapper: (env) => env.name,
        );
      } else {
        if (configEnvironment != null) {
          environments = [configEnvironment];
        }
      }
    }

    return environments;
  }

  bool get isClean => args['clean'];

  Future<bool> ensurePackageRegistered(String packageName, {required bool isDevDependency}) async {
    if (await isPackageRegistered(packageName, isDevDependency: isDevDependency)) {
      return true;
    }

    final shouldAddPackage = confirm(
        '`$packageName` needs to be installed. Would you like to add `$packageName` as a ${isDevDependency ? 'dev_dependency' : 'dependency'}?');

    if (!shouldAddPackage) {
      return false;
    }

    await registerPackage(packageName, isDevDependency: isDevDependency);

    return true;
  }

  Future<Map<String, dynamic>?> getConfig() async {
    return await _configDataSource().getData();
  }

  Future<void> saveConfig(Map<String, dynamic> data) async {
    await _configDataSource().saveData(data);
  }

  DataSource<Map<String, dynamic>> _configDataSource() {
    return FileDataSource(file: Directory.current / 'assets' - 'config.yaml').mapYaml();
  }

  Environment? _environmentFromNameOrNull(String envName) {
    return Environment.values.firstWhereOrNull((env) => env.name == envName);
  }
}

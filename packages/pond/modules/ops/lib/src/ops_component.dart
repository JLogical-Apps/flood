import 'package:collection/collection.dart';
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:pond_cli/pond_cli.dart';

class OpsAutomateComponent with IsAutomatePondComponent {
  final Map<EnvironmentType, OpsEnvironment> environments;

  OpsAutomateComponent({required this.environments});

  @override
  List<AutomateCommand> get commands => [
        DeployCommand(environments: environments),
        DeleteCommand(environments: environments),
      ];
}

class DeployCommand extends AutomateCommand<DeployCommand> {
  final Map<EnvironmentType, OpsEnvironment> environments;

  late final environmentProperty = field<String>(name: 'environment').required();

  DeployCommand({required this.environments});

  @override
  String get name => 'deploy';

  @override
  String get description => 'Deploys a build to an environment.';

  @override
  DeployCommand copy() {
    return DeployCommand(environments: environments);
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final environmentType = getEnvironmentType();
    final opsEnvironment = environments[environmentType] ??
        (throw Exception('Could not find associated ops environment for [${environmentType.name}]!'));

    var exists = await opsEnvironment.exists(context, environmentType: environmentType);
    if (!exists) {
      if (!context.coreProject
          .confirm('Environment for [${environmentType.name}] does not exist. Would you like to create it?')) {
        return;
      }

      await opsEnvironment.onCreate(context, environmentType: environmentType);

      exists = await opsEnvironment.exists(context, environmentType: environmentType);
      if (!exists) {
        throw Exception('Could not successfully create the environment');
      }
    }

    await opsEnvironment.deploy(context, environmentType: environmentType);
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.property(environmentProperty);

  EnvironmentType? getEnvironmentTypeOrNull() {
    return EnvironmentType.static.defaultTypes
        .firstWhereOrNull((environment) => environment.name == environmentProperty.value);
  }

  EnvironmentType getEnvironmentType() {
    return getEnvironmentTypeOrNull() ??
        (throw Exception('Could not find environment with name [${environmentProperty.value}]!'));
  }
}

class DeleteCommand extends AutomateCommand<DeleteCommand> {
  final Map<EnvironmentType, OpsEnvironment> environments;

  late final environmentProperty = field<String>(name: 'environment').required();

  DeleteCommand({required this.environments});

  @override
  String get name => 'delete';

  @override
  String get description => 'Deletes an environment.';

  @override
  DeleteCommand copy() {
    return DeleteCommand(environments: environments);
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final environmentType = getEnvironmentType();
    final opsEnvironment = environments[environmentType] ??
        (throw Exception('Could not find associated ops environment for [${environmentType.name}]!'));

    final exists = await opsEnvironment.exists(context, environmentType: environmentType);
    if (!exists) {
      context.coreProject
          .warning('Ops environment for [${environmentType.name}] does not exist, so nothing will be deleted.');
      return;
    }

    await opsEnvironment.delete(context, environmentType: environmentType);
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.property(environmentProperty);

  EnvironmentType? getEnvironmentTypeOrNull() {
    return EnvironmentType.static.defaultTypes
        .firstWhereOrNull((environment) => environment.name == environmentProperty.value);
  }

  EnvironmentType getEnvironmentType() {
    return getEnvironmentTypeOrNull() ??
        (throw Exception('Could not find environment with name [${environmentProperty.value}]!'));
  }
}

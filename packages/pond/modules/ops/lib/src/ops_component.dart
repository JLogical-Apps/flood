import 'package:collection/collection.dart';
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/build.dart';
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

class DeployCommand extends AutomateCommand<DeleteCommand> {
  final Map<EnvironmentType, OpsEnvironment> environments;

  late final environmentProperty = field<String>(name: 'environment').required();
  late final buildProperty = field<String>(name: 'build').required();

  DeployCommand({required this.environments});

  @override
  String get name => 'deploy';

  @override
  String get description => 'Deploys a build to an environment.';

  @override
  DeleteCommand copy() {
    return DeleteCommand(environments: environments);
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final environmentType = getEnvironmentType();
    final opsEnvironment = environments[environmentType] ??
        (throw Exception('Could not find associated ops environment for [${environmentType.name}]!'));

    var exists = await opsEnvironment.exists(context);
    if (!exists) {
      if (!context.confirm('Environment for [${environmentType.name}] does not exist. Would you like to create it?')) {
        return;
      }

      await opsEnvironment.onCreate(context);

      exists = await opsEnvironment.exists(context);
      if (!exists) {
        throw Exception('Could not successfully create the environment');
      }
    }

    final environmentInfo = await opsEnvironment.getInfo(context);
    context.print('${environmentType.name} Info:');
    context.print('  - Build: [${environmentInfo.build}]');

    if (!context.confirm('Are you sure you want to deploy [${buildProperty.value}] to [${environmentType.name}]?')) {
      return;
    }

    await opsEnvironment.deploy(context, build: Build());
  }

  @override
  AutomatePathDefinition get pathDefinition =>
      AutomatePathDefinition.property(environmentProperty).property(buildProperty);

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

    final exists = await opsEnvironment.exists(context);
    if (!exists) {
      context.warning('Ops environment for [${environmentType.name}] does not exist, so nothing will be deleted.');
      return;
    }

    final environmentInfo = await opsEnvironment.getInfo(context);
    context.print('${environmentType.name} Info:');
    context.print('  - Build: [${environmentInfo.build}]');

    if (!context.confirm('Are you sure you want to delete [${environmentType.name}]?')) {
      return;
    }

    await opsEnvironment.delete(context);
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

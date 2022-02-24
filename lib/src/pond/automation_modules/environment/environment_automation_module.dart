import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/pond/automation_modules/environment/environment_listening_automation_module.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

import '../../modules/environment/environment.dart';

class EnvironmentAutomationModule extends AutomationModule {
  @override
  String get name => 'Environment';

  EnvironmentAutomationModule() {
    final environmentAutomations = registerAutomation(
      name: 'environment',
      description: 'Commands relating to the environment.',
    );
    environmentAutomations.registerAutomation(
      name: 'set',
      description: 'Set the environment. The name of the environment should be listed as the last parameter.',
      action: _setEnvironment,
      category: 'environment',
    );
  }

  Future<void> _setEnvironment(AutomationContext context) async {
    final environmentName = context.args.rest.lastOrNull ?? (throw Exception('Environment name should be set last'));
    final environment = Environment.values.where((env) => env.name == environmentName).firstOrNull ??
        (throw Exception('Could not find environment with name $environmentName'));

    final config = await context.getConfig();
    final oldEnvironmentName = config?['env'];
    final oldEnvironment = Environment.values.where((env) => env.name == oldEnvironmentName).firstOrNull;

    await context.updateConfigField('env', environmentName);

    await Future.wait(context.modules
        .whereType<EnvironmentListeningAutomationModule>()
        .map((e) => e.onEnvironmentChanged(context, oldEnvironment, environment)));
  }
}

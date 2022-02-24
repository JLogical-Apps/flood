import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

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
    await context.updateConfigField('env', environmentName);
  }
}

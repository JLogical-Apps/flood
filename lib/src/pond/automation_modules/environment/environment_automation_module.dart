import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/simple_command.dart';
import 'package:jlogical_utils/src/pond/automation_modules/environment/environment_listening_automation_module.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

class EnvironmentAutomationModule extends AutomationModule {
  @override
  String get name => 'Environment';

  @override
  List<Command> get commands => [
        SimpleCommand(
          name: 'environment_set',
          displayName: 'Set Environment',
          description: 'Set the environment.',
          category: 'Environment',
          parameters: {
            'env': CommandParameter.string(
              displayName: 'Environment',
              description: 'The environment to set to.',
            ),
          },
          runner: (args) async {
            final environmentName = args['env'];
            final environment = Environment.values.where((env) => env.name == environmentName).firstOrNull ??
                (throw Exception('Could not find environment with name $environmentName'));

            final config = await context.getConfig();
            final oldEnvironmentName = config?['env'];
            final oldEnvironment = Environment.values.where((env) => env.name == oldEnvironmentName).firstOrNull;

            if (environment == oldEnvironment) {
              return;
            }

            await context.updateConfigField('env', environmentName);

            for (final module in AutomationContext.global.modules.whereType<EnvironmentListeningAutomationModule>()) {
              await module.onEnvironmentChanged(oldEnvironment, environment);
            }
          },
        ),
      ];
}

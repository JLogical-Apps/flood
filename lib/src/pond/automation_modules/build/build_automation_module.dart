import 'package:jlogical_utils/src/pond/automation_modules/build/building_automation_module.dart';

import '../../automation/automation_context.dart';
import '../../automation/automation_module.dart';
import '../../automation/automations_provider.dart';
import '../../modules/environment/environment.dart';

class BuildAutomationModule extends AutomationModule {
  @override
  String get name => 'Build';

  BuildAutomationModule() {
    registerAutomation(
      name: 'build',
      description: 'Builds the app.',
      action: _build,
      category: null,
      args: (args) {
        args.addOption(
          'environment',
          help: 'The environment to build the app for.',
          allowed: Environment.values.map((env) => env.name).toList(),
          aliases: ['env'],
          defaultsTo: Environment.device.name,
        );
        args.addFlag(
          'clean',
          help: 'Whether to build the app from a clean slate.',
          negatable: false,
        );
      },
    );
  }
}

Future<void> _build(AutomationContext context) async {
  if (context.isClean) {
    context.print('Building a clean version of the app!');
  } else {
    context.print('Building the app!');
  }
  await Future.wait(context.modules.whereType<BuildingAutomationModule>().map((module) => module.onBuild(context)));
}

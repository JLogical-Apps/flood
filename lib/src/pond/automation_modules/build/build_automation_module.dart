import 'package:jlogical_utils/src/pond/automation_modules/build/building_automation_module.dart';

import '../../automation/automation_context.dart';
import '../../automation/automation_module.dart';
import '../../automation/automations_provider.dart';
import '../../modules/environment/environment.dart';

class BuildAutomationModule extends AutomationModule {
  @override
  String get name => 'Build';

  @override
  List<Command> get commands => [
        SimpleCommand(
          name: 'build',
          description: 'Builds the app.',
          runner: (args) => _build,
          category: 'Build',
          parameters: {
            'clean': CommandParameter.bool(
              displayName: 'Clean',
              description: 'Whether to build the app from a clean slate.',
            )
          },
        ),
      ];

  Future<void> _build(Map<String, dynamic>? args) async {
    final isClean = args?['clean'] ?? false;
    if (isClean) {
      context.print('Building a clean version of the app!');
    } else {
      context.print('Building the app!');
    }

    await Future.wait(context.modules.whereType<BuildingAutomationModule>().map((module) => module.onBuild(isClean)));
  }
}

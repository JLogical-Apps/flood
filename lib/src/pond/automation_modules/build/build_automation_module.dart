import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/simple_command.dart';

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

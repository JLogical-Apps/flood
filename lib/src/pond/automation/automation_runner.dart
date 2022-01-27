import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'automation_context.dart';

Future<void> runAutomation(List<String> args, {required AutomationContext automationContext}) async {
  final runner = CommandRunner('automate', 'Run an automation.');
  automationContext.automations.forEach((automation) {
    runner.addCommand(SimpleCommand(
      name: automation.name,
      description: automation.description ?? 'N/A',
      args: automation.args,
      onRun: (args) {
        automationContext.args = args;
        return automation.action(automationContext);
      },
    ));
  });
  runner.run(args);
}

class SimpleCommand extends Command {
  @override
  final String name;

  @override
  final String description;

  final Future<void> Function(ArgResults args) onRun;

  SimpleCommand({
    required this.name,
    required this.description,
    required this.onRun,
    Function(ArgParser args)? args,
  }) {
    args?.call(argParser);
  }

  @override
  Future<void> run() => onRun(argResults!);
}

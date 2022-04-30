import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import 'automation.dart';
import 'automation_context.dart';

Future<void> runAutomation(List<String> args, {required AutomationContext automationContext}) async {
  final runner = CommandRunner('automate', 'Run an automation.');
  automationContext.automations.forEach((automation) => runner.addCommand(_commandFromAutomation(
        automationContext,
        automation: automation,
      )));
  try {
    await runner.run(args);
  } on UsageException catch (e) {
    automationContext.print(e);
  }
}

SimpleCommand _commandFromAutomation(AutomationContext context, {required Automation automation}) {
  final command = SimpleCommand(
    name: automation.name,
    description: automation.description ?? 'N/A',
    category: automation.category,
    args: automation.args,
    onRun: automation.action.mapIfNonNull((action) => (args) {
          context.args = args;
          return action(context);
        }),
  );
  automation.automations.forEach((automation) {
    command.addSubcommand(_commandFromAutomation(
      context,
      automation: automation,
    ));
  });
  return command;
}

class SimpleCommand extends Command {
  @override
  final String name;

  @override
  final String description;

  @override
  final String category;

  final Future<void> Function(ArgResults args)? onRun;

  SimpleCommand({
    required this.name,
    required this.description,
    required this.onRun,
    String? category,
    Function(ArgParser args)? args,
  }) : this.category = category ?? '' {
    args?.call(argParser);
  }

  @override
  Future<void> run() async => await onRun?.call(argResults!);
}

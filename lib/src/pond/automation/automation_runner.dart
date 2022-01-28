import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'automation_context.dart';

Future<void> runAutomation(List<String> args, {required AutomationContext automationContext}) async {
  final runner = CommandRunner('automate', 'Run an automation.');
  automationContext.automations.forEach((automation) {
    runner.addCommand(SimpleCommand(
      name: automation.name,
      description: automation.description ?? 'N/A',
      category: automation.category,
      args: automation.args,
      onRun: (args) {
        automationContext.args = args;
        return automation.action(automationContext);
      },
    ));
  });
  try {
    await runner.run(args);
  } on UsageException catch (e) {
    automationContext.print(e);
  }
  exit(0);
}

class SimpleCommand extends Command {
  @override
  final String name;

  @override
  final String description;

  @override
  final String category;

  final Future<void> Function(ArgResults args) onRun;

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
  Future<void> run() => onRun(argResults!);
}

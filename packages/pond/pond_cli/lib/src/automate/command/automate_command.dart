import 'dart:async';

import 'package:pond_cli/src/automate/command/automate_command_context.dart';

abstract class AutomateCommand {
  String get name;

  String get description;

  Future<void> onRun(AutomateCommandContext context);

  factory AutomateCommand({
    required String name,
    required String description,
    required FutureOr Function(AutomateCommandContext context) runner,
  }) =>
      _AutomateCommandImpl(name: name, description: description, runner: runner);
}

class _AutomateCommandImpl implements AutomateCommand {
  @override
  final String name;

  @override
  final String description;

  final FutureOr Function(AutomateCommandContext context) runner;

  _AutomateCommandImpl({required this.name, required this.description, required this.runner});

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    await runner(context);
  }
}

extension AutomateCommandDefaults on AutomateCommand {
  Future<void> run(AutomateCommandContext context) async {
    await onRun(context);
  }
}

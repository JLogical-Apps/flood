import 'dart:async';

import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';

class SimpleCommand extends Command {
  @override
  String name;

  @override
  String displayName;

  @override
  String? description;

  String? category;

  @override
  Map<String, CommandParameter> parameters;

  FutureOr Function(Map<String, dynamic> args) runner;

  SimpleCommand({
    required this.name,
    String? displayName,
    this.description,
    this.category,
    this.parameters: const {},
    required this.runner,
  }) : this.displayName = displayName ?? name;

  SimpleCommand.wildcard({
    String? displayName,
    this.description,
    this.parameters: const {},
    this.category,
    required this.runner,
  })  : name = Command.wildcardName,
        this.displayName = displayName ?? 'Wildcard';

  SimpleCommand.fromCommand(Command command)
      : name = command.name,
        displayName = command.displayName,
        parameters = command.parameters,
        description = command.description,
        category = (command as SimpleCommand?)?.category,
        runner = command.run;

  @override
  FutureOr onExecute(Map<String, dynamic> args) => runner(args);
}

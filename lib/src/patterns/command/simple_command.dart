import 'dart:async';

import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';

class SimpleCommand extends Command {
  @override
  final String name;

  @override
  final String displayName;

  @override
  final String? description;

  @override
  final String? category;

  @override
  final Map<String, CommandParameter> parameters;

  final FutureOr Function(Map<String, dynamic> args) runner;

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
    required this.runner,
  })  : name = Command.wildcardName,
        category = null,
        this.displayName = displayName ?? 'Wildcard';

  @override
  FutureOr onExecute(Map<String, dynamic> args) => runner(args);
}

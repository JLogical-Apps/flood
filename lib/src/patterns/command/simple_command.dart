import 'dart:async';

import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';

class SimpleCommand extends Command {
  final String name;
  final Map<String, CommandParameter> parameters;
  final FutureOr Function(Map<String, dynamic> args) runner;

  SimpleCommand({required this.name, this.parameters: const {}, required this.runner});

  SimpleCommand.wildcard({this.parameters: const {}, required this.runner}) : name = Command.wildcardName;

  @override
  FutureOr onExecute(Map<String, dynamic> args) => runner(args);
}

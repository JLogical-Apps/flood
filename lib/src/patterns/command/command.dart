import 'dart:async';

import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';

abstract class Command {
  /// If the name of the command is `*`, then it accepts any command in the command runner that didn't match any other
  /// predefined command, and `args` will contain a `_name` key which maps to the name of the command that wasn't found.
  static const String wildcardName = '*';

  /// The name of the command, which is used to identify the command when trying to be run.
  String get name;

  Map<String, CommandParameter> get parameters;

  FutureOr onExecute(Map<String, dynamic> args);

  bool get isWildcard => name == wildcardName;

  Future<dynamic> run([Map<String, dynamic> args = const {}]) async {
    if (!_argsMatchesParams(args)) {
      throw Exception('Cannot run Command [$name] with args [$args]');
    }

    return await onExecute(args);
  }

  bool _argsMatchesParams(Map<String, dynamic> args) {
    for (final entry in parameters.entries) {
      final name = entry.key;
      final param = entry.value;

      final arg = args[name];

      if (!param.matches(arg)) {
        return false;
      }
    }

    return true;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'parameters': parameters.map((name, parameter) => MapEntry(name, parameter.toString())),
      };
}

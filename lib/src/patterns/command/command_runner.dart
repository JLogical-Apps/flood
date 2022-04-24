import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

class CommandRunner {
  final List<Command> commands;

  const CommandRunner({required this.commands});

  Future<dynamic> run({required String commandName, Map<String, dynamic> args: const {}}) async {
    final command = _getCommandByName(commandName) ?? (throw Exception('Cannot find command with name [$commandName]'));
    if (command.isWildcard) {
      args = args.copy()..set('_name', commandName);
    }
    return await command.run(args);
  }

  bool hasCommandByName(String name) {
    return _getCommandByName(name) != null;
  }

  Command? _getCommandByName(String name) {
    final command = commands.firstWhereOrNull((command) => command.name == name);
    if (command != null) {
      return command;
    }

    final wildcardCommand = commands.firstWhereOrNull((command) => command.name == Command.wildcardName);
    if (wildcardCommand != null) {
      return wildcardCommand;
    }

    return null;
  }
}

import 'dart:async';

import 'package:jlogical_utils/src/remote/remote_message.dart';

import '../patterns/command/command.dart';
import '../patterns/command/command_runner.dart';
import '../persistence/ids/uuid_id_generator.dart';

const String _commandNameField = '_name';
const String _commandResultField = 'result';
const String _commandErrorField = 'error';

abstract class AbstractRemoteCommunicator {
  final CommandRunner _commandRunner;

  final Map<String, Completer<Map<String, dynamic>>> _completerById = {};

  AbstractRemoteCommunicator({List<Command> commands: const []}) : _commandRunner = CommandRunner(commands: commands);

  void sendRemoteMessage(RemoteMessage message);

  bool get isConnected;

  Future<dynamic> run({required String commandName, Map<String, dynamic> args: const {}}) async {
    return await get(
      code: RemoteMessage.codeExecuteCommand,
      args: {
        _commandNameField: commandName,
        ...args,
      },
    );
  }

  Future<dynamic> get({required String code, Map<String, dynamic> args: const {}}) async {
    final id = UuidIdGenerator().getId(null);
    final completer = Completer<Map<String, dynamic>>();
    _completerById[id] = completer;

    sendMessage(code: code, id: id, args: args);

    final resultJson = await completer.future.timeout(Duration(seconds: 10));

    final error = resultJson[_commandErrorField];
    if (error != null) {
      throw Exception(error);
    }

    return resultJson[_commandResultField];
  }

  void sendMessage({required String code, String? id, Map<String, dynamic> args: const {}}) {
    final remoteMessage = RemoteMessage(code: code, id: id, args: args);
    sendRemoteMessage(remoteMessage);
  }

  void onMessageReceived(RemoteMessage message) {
    final isResponse = message.code == RemoteMessage.codeResponse;
    if (isResponse) {
      _handleResponse(message);
      return;
    }

    final isExecute = message.code == RemoteMessage.codeExecuteCommand;
    if (isExecute) {
      _handleExecute(message);
      return;
    }

    throw Exception('Invalid message code: [${message.code}]');
  }

  void _handleResponse(RemoteMessage message) {
    final id = message.id ?? (throw Exception('Cannot handle response to message with no id!'));
    final existingCompleter = _completerById.remove(id);
    if (existingCompleter == null) {
      return;
    }

    existingCompleter.complete(message.args);
  }

  Future<void> _handleExecute(RemoteMessage message) async {
    final id = message.id ?? (throw Exception('To execute a command, it must have an id!'));
    String commandName =
        message.args[_commandNameField] ?? (throw Exception('To execute a command, it must have a command name!'));

    final hasCommand = _commandRunner.hasCommandByName(commandName);
    if (!hasCommand) {
      throw Exception('Cannot find command with name [$commandName]');
    }

    try {
      final result = await _commandRunner.run(commandName: commandName, args: message.args);
      sendMessage(
        code: RemoteMessage.codeResponse,
        id: id,
        args: {_commandResultField: result},
      );
    } catch (e) {
      sendMessage(
        code: RemoteMessage.codeResponse,
        id: id,
        args: {_commandErrorField: e.toString()},
      );
    }
  }
}

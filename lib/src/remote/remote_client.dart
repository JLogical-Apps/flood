import 'dart:convert';

import 'package:jlogical_utils/src/remote/remote_message.dart';
import 'package:web_socket_channel/io.dart';

import '../patterns/command/command.dart';
import 'abstract_remote_communicator.dart';

class RemoteClient extends AbstractRemoteCommunicator {
  final IOWebSocketChannel webSocket;

  bool isConnected = true;

  RemoteClient({required this.webSocket, List<Command> commands: const []}) : super(commands: commands) {
    webSocket.stream.listen(
      (event) {
        final json = JsonDecoder().convert(event);
        final message = RemoteMessage.fromJson(json);
        onMessageReceived(message);
      },
      onDone: () {
        isConnected = false;
      },
    );
  }

  @override
  void sendRemoteMessage(RemoteMessage message) {
    final json = message.toJson();
    final jsonString = JsonEncoder().convert(json);

    webSocket.sink.add(jsonString);
  }
}

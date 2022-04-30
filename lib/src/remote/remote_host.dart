import 'dart:convert';

import 'package:jlogical_utils/remote.dart';
import 'package:jlogical_utils/src/remote/remote_message.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../patterns/command/command.dart';
import 'abstract_remote_communicator.dart';

class RemoteHost extends AbstractRemoteCommunicator {
  final String address;
  final int port;

  WebSocketChannel? _currentWebSocket;

  RemoteHost._({required this.address, required this.port, List<Command> commands: const []})
      : super(commands: commands);

  @override
  bool get isConnected => _currentWebSocket != null;

  @override
  void sendRemoteMessage(RemoteMessage message) {
    final json = message.toJson();
    final jsonString = JsonEncoder().convert(json);

    _currentWebSocket?.sink.add(jsonString);
  }

  static Future<RemoteHost> initialize({
    String address: '127.0.0.1',
    int port: 1236,
    List<Command> commands: const [],
  }) async {
    final host = RemoteHost._(address: address, port: port, commands: commands);
    await host._initialize();
    return host;
  }

  static Future<RemoteClient> connect({
    String address: '127.0.0.1',
    int port: 1236,
    List<Command> commands: const [],
  }) async {
    final socket = IOWebSocketChannel.connect(Uri.parse('ws://$address:$port'));
    return RemoteClient(webSocket: socket, commands: commands);
  }

  Future<void> _initialize() async {
    final handler = webSocketHandler((WebSocketChannel webSocket) {
      if (_currentWebSocket != null) {
        _currentWebSocket!.sink.close();
      }

      _currentWebSocket = webSocket;

      print('[$port] Connected to client');

      webSocket.stream.listen(
        (event) {
          final json = JsonDecoder().convert(event);
          final message = RemoteMessage.fromJson(json);
          onMessageReceived(message);
        },
        onDone: () {
          print('[$port] Disconnected from client.');

          if (_currentWebSocket == webSocket) {
            _currentWebSocket = null;
            print('[$port] All clients clear.');
          }
        },
      );
    });

    final server = await io.serve(handler, address, port);
    print('Serving at ws://${server.address.host}:${server.port}');
  }
}

import 'dart:io';

import 'package:pond_cli/pond_cli.dart';

class WithoutRunTerminal with IsTerminalWrapper {
  @override
  final Terminal terminal;

  WithoutRunTerminal({required this.terminal});

  @override
  Future<String> run(
    String command, {
    Directory? workingDirectory,
    bool interactable = false,
    Map<String, String> environment = const {},
  }) {
    throw Exception('Cannot run commands from this terminal!');
  }
}

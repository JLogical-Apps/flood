import 'dart:io';

import 'package:pond_cli/pond_cli.dart';

class WorkingDirectoryTerminal with IsTerminalWrapper {
  @override
  final Terminal terminal;

  final Directory workingDirectory;

  WorkingDirectoryTerminal({required this.terminal, required this.workingDirectory});

  @override
  Future<String> run(
    String command, {
    Directory? workingDirectory,
    bool interactable = false,
    Map<String, String> environment = const {},
  }) {
    return terminal.run(
      command,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      interactable: interactable,
      environment: environment,
    );
  }
}

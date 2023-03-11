import 'dart:io';

import 'package:pond_cli/src/automate/util/terminal/capture_terminal.dart';
import 'package:pond_cli/src/automate/util/terminal/shell_terminal.dart';

abstract class Terminal {
  void print(dynamic obj);

  void warning(dynamic obj);

  void error(dynamic obj);

  bool confirm(String prompt);

  String input(String prompt);

  T select<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
    T? initialValue,
  });

  List<T> multiSelect<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
  });

  Future<void> run(String command, {Directory? workingDirectory});

  static TerminalStatic get static => TerminalStatic();
}

class TerminalStatic {
  Terminal get shell => ShellTerminal();

  CaptureTerminal get capture => CaptureTerminal();
}

mixin IsTerminal implements Terminal {}

abstract class TerminalWrapper implements Terminal {
  Terminal get terminal;
}

mixin IsTerminalWrapper implements TerminalWrapper {
  @override
  void print(dynamic obj) => terminal.print(obj);

  @override
  void warning(dynamic obj) => terminal.warning(obj);

  @override
  void error(dynamic obj) => terminal.error(obj);

  @override
  bool confirm(String prompt) => terminal.confirm(prompt);

  @override
  String input(String prompt) => terminal.input(prompt);

  @override
  T select<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
    T? initialValue,
  }) =>
      terminal.select(
        prompt: prompt,
        options: options,
        stringMapper: stringMapper,
        initialValue: initialValue,
      );

  @override
  List<T> multiSelect<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
  }) =>
      terminal.multiSelect(
        prompt: prompt,
        options: options,
        stringMapper: stringMapper,
      );

  @override
  Future<void> run(String command, {Directory? workingDirectory}) => terminal.run(
        command,
        workingDirectory: workingDirectory,
      );
}

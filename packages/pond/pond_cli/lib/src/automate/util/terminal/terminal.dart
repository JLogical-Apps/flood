import 'dart:io';

import 'package:pond_cli/src/automate/util/terminal/capture_terminal.dart';
import 'package:pond_cli/src/automate/util/terminal/shell_terminal.dart';
import 'package:pond_cli/src/automate/util/terminal/without_run_terminal.dart';

abstract class Terminal {
  void print(dynamic obj);

  void warning(dynamic obj);

  void error(dynamic obj);

  bool confirm(String prompt);

  String input(String prompt, {String? hintText, String? initialText});

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

  /// Runs the [command] (or multiple commands if split by a `\n`) in [workingDirectory].
  /// If [interactable] is true, then enables user interaction in the [command], such as inputting login credentials for `firebase login`. But, this prevents any output from being returned due to the quirks of [dcli].
  Future<String> run(String command, {Directory? workingDirectory, bool interactable = false});

  static TerminalStatic get static => TerminalStatic();
}

extension TerminalExtensions on Terminal {
  Terminal withoutRun() => WithoutRunTerminal(terminal: this);
}

class TerminalStatic {
  Terminal shell({Directory? workingDirectory}) => ShellTerminal(workingDirectory: workingDirectory);

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
  String input(String prompt, {String? hintText, String? initialText}) => terminal.input(prompt, hintText: hintText, initialText: initialText);

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
  Future<String> run(String command, {Directory? workingDirectory, bool interactable = false}) => terminal.run(
        command,
        workingDirectory: workingDirectory,
        interactable: interactable,
      );
}

import 'dart:core' as core;
import 'dart:core';
import 'dart:io';

import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:dcli/dcli.dart' as dcli;
import 'package:dcli/dcli.dart';
import 'package:interact/interact.dart';
import 'package:interact/interact.dart' as interact;
import 'package:lumberdash/lumberdash.dart' as lumberdash;
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';

class ShellTerminal with IsTerminal {
  bool _isLumberdashInitialized = false;

  @override
  void print(obj) {
    _initializeLumberdashIfNeeded();
    lumberdash.logMessage('$obj');
  }

  @override
  void warning(obj) {
    _initializeLumberdashIfNeeded();
    lumberdash.logWarning('$obj');
  }

  @override
  void error(obj) {
    _initializeLumberdashIfNeeded();
    lumberdash.logError('$obj', stacktrace: StackTrace.current);
  }

  @override
  bool confirm(String prompt) {
    return interact.Confirm(prompt: prompt, waitForNewLine: true).interact();
  }

  @override
  String input(String prompt) {
    return Input(prompt: prompt).interact();
  }

  @override
  T select<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
    T? initialValue,
  }) {
    final selectedIndex = Select(
      prompt: prompt,
      options: options.map(stringMapper).toList(),
      initialIndex: initialValue
              ?.mapIfNonNull((initialValue) => options.contains(initialValue) ? options.indexOf(initialValue) : null) ??
          0,
    ).interact();
    return options[selectedIndex];
  }

  @override
  List<T> multiSelect<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
  }) {
    final selectedIndices = MultiSelect(prompt: prompt, options: options.map(stringMapper).toList()).interact();
    return selectedIndices.map((index) => options[index]).toList();
  }

  @override
  Future<void> run(String command, {Directory? workingDirectory}) async {
    command.split('\n').forEach((line) {
      core.print('> $line');
      dcli.start(
        line,
        workingDirectory: workingDirectory?.path,
        terminal: true,
        runInShell: true,
        progress: dcli.Progress(print, stderr: printerr),
      );
      core.print('');
    });
  }

  void _initializeLumberdashIfNeeded() {
    if (!_isLumberdashInitialized) {
      _isLumberdashInitialized = true;
      lumberdash.putLumberdashToWork(withClients: [ColorizeLumberdash()]);
    }
  }
}

import 'dart:core' as core;
import 'dart:core';
import 'dart:io';

import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:dcli/dcli.dart' as dcli;
import 'package:interact/interact.dart';
import 'package:interact/interact.dart' as interact;
import 'package:lumberdash/lumberdash.dart' as lumberdash;
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';

class ShellTerminal with IsTerminal {
  final Directory? workingDirectory;

  bool _isLumberdashInitialized = false;

  ShellTerminal({this.workingDirectory});

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
  String input(String prompt, {String? hintText, String? initialText}) {
    return dcli.ask(prompt, defaultValue: initialText);
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
  Future<String> run(
    String command, {
    Directory? workingDirectory,
    bool interactable = false,
    Map<String, String> environment = const {},
  }) async {
    return await dcli.withEnvironment(
      () async {
        return command.split('\n').map((line) {
          core.print('> $line');
          final progress = dcli.start(
            line,
            workingDirectory: (workingDirectory ?? this.workingDirectory)?.path,
            terminal: interactable,
            runInShell: true,
            progress: dcli.Progress.print(capture: true),
          );
          core.print('');
          return progress.lines.join('\n');
        }).join('\n');
      },
      environment: environment,
    );
  }

  void _initializeLumberdashIfNeeded() {
    if (!_isLumberdashInitialized) {
      _isLumberdashInitialized = true;
      lumberdash.putLumberdashToWork(withClients: [ColorizeLumberdash()]);
    }
  }
}

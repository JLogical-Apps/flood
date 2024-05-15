import 'dart:core' as core;
import 'dart:core';
import 'dart:io';

import 'package:dcli/dcli.dart' as dcli;
import 'package:mason_logger/mason_logger.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';

class ShellTerminal with IsTerminal {
  final Directory? workingDirectory;

  final Logger _masonLogger = Logger();

  ShellTerminal({this.workingDirectory});

  @override
  void print(obj) {
    _masonLogger.info('$obj');
  }

  @override
  void warning(obj) {
    _masonLogger.warn('$obj');
  }

  @override
  void error(obj) {
    _masonLogger.err('$obj\n${StackTrace.current}');
  }

  @override
  bool confirm(String prompt) {
    return _masonLogger.confirm(prompt);
  }

  @override
  String input(String prompt, {String? hintText, String? initialText}) {
    return _masonLogger.prompt(prompt, defaultValue: initialText);
  }

  @override
  T select<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
    T? initialValue,
  }) {
    return _masonLogger.chooseOne(
      prompt,
      choices: options,
      display: stringMapper,
      defaultValue: initialValue,
    );
  }

  @override
  Future<String> run(
    String command, {
    Directory? workingDirectory,
    bool interactable = false,
    Map<String, String> environment = const {},
  }) async {
    return await dcli.withEnvironmentAsync(
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
}

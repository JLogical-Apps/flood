import 'dart:io';

import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';

class CaptureTerminal with IsTerminal {
  final List<String> output = [];

  @override
  bool confirm(String prompt) {
    output.add('confirm: $prompt');
    return false;
  }

  @override
  void error(obj) {
    output.add('error: $obj');
  }

  @override
  String input(String prompt, {String? hintText, String? initialText}) {
    output.add('input: $prompt');
    return '';
  }

  @override
  List<T> multiSelect<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
  }) {
    output.add('multiSelect: $prompt, [${options.map(stringMapper).join(',')}]');
    return [];
  }

  @override
  void print(obj) {
    output.add('print: $obj');
  }

  @override
  Future<String> run(String command, {Directory? workingDirectory, bool interactable = false}) async {
    final directoryString = workingDirectory == null ? '' : ' ${workingDirectory.relativePath}';
    output.add('run: $command$directoryString');
    return 'run: $command$directoryString';
  }

  @override
  T select<T>({
    required String prompt,
    required List<T> options,
    required String Function(T value) stringMapper,
    T? initialValue,
  }) {
    output.add('select: $prompt, [${options.map(stringMapper).join(',')}');
    return options[0];
  }

  @override
  void warning(obj) {
    output.add('warning: $obj');
  }
}

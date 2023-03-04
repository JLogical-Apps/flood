import 'dart:io';

import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:dcli/dcli.dart' as dcli;
import 'package:dcli/dcli.dart';
import 'package:interact/interact.dart';
import 'package:lumberdash/lumberdash.dart' as lumberdash;
import 'package:pond_core/src/automate/util/terminal/terminal.dart';

class ShellTerminal with IsTerminal {
  @override
  bool confirm(String prompt) {
    // TODO: implement confirm
    throw UnimplementedError();
  }

  @override
  void error(obj) {
    // TODO: implement error
  }

  @override
  String input(String prompt) {
    // TODO: implement input
    throw UnimplementedError();
  }

  @override
  List<T> multiSelect<T>(
      {required String prompt, required List<T> options, required String Function(T value) stringMapper}) {
    // TODO: implement multiSelect
    throw UnimplementedError();
  }

  @override
  void print(obj) {
    // TODO: implement print
  }

  @override
  Future<void> run(String command, {Directory? workingDirectory}) {
    // TODO: implement run
    throw UnimplementedError();
  }

  @override
  T select<T>(
      {required String prompt,
      required List<T> options,
      required String Function(T value) stringMapper,
      T? initialValue}) {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  void warning(obj) {
    // TODO: implement warning
  }
}

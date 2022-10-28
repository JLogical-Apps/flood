import 'dart:async';

abstract class AutomateCommand {
  String get name;

  Future<void> onRun();

  factory AutomateCommand({required String name, required FutureOr Function() runner}) =>
      _AutomateCommandImpl(name: name, runner: runner);
}

class _AutomateCommandImpl implements AutomateCommand {
  @override
  final String name;

  final FutureOr Function() runner;

  _AutomateCommandImpl({required this.name, required this.runner});

  @override
  Future<void> onRun() async {
    await runner();
  }
}

extension AutomateCommandDefaults on AutomateCommand {
  Future<void> run() async {
    await onRun();
  }
}

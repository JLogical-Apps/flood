import 'dart:async';

import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/task_runner.dart';

abstract class Task<R extends Route, T> {
  String get name;

  Future<T> onRun(R route);

  factory Task({required String name, required FutureOr<T> Function(R route) runner}) =>
      _TaskImpl(name: name, runner: runner);
}

mixin IsTask<R extends Route, T> implements Task<R, T> {}

extension TaskExtensions<R extends Route, T> on Task<R, T> {
  Future<T> executeOn({required R route, required TaskRunner taskRunner}) {
    return taskRunner.run(this, route);
  }
}

class _TaskImpl<R extends Route, T> with IsTask<R, T> {
  @override
  final String name;

  final FutureOr<T> Function(R route) runner;

  _TaskImpl({required this.name, required this.runner});

  @override
  Future<T> onRun(R route) async {
    return await runner(route);
  }
}

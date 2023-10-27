import 'dart:async';

import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/local/local_task_runner.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/trigger/trigger.dart';

abstract class TaskRunner {
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route);

  Future onRegisterTrigger(Trigger trigger);

  static final TaskRunnerStatic static = TaskRunnerStatic();

  factory TaskRunner({
    required FutureOr<O> Function<T extends Task<R, O>, R extends Route, O>(T task, R route) runner,
    FutureOr Function(Trigger trigger)? triggerRegisterer,
  }) =>
      _TaskRunnerImpl(
        runner: runner,
        triggerRegisterer: triggerRegisterer,
      );
}

class TaskRunnerStatic {
  TaskRunner get none => TaskRunner(
        runner: <T extends Task<R, O>, R extends Route, O>(task, route) =>
            throw Exception('This environment cannot run tasks!'),
      );

  TaskRunner get local => LocalTaskRunner();
}

extension TaskRunnerExtensions on TaskRunner {
  Future<O> runTask<T extends Task<R, O>, R extends Route, O>(T task, R route) {
    return onRun(task, route);
  }

  Future registerTrigger(Trigger trigger) => onRegisterTrigger(trigger);
}

mixin IsTaskRunner implements TaskRunner {}

class _TaskRunnerImpl with IsTaskRunner {
  final FutureOr<O> Function<T extends Task<R, O>, R extends Route, O>(T task, R route) runner;
  final FutureOr Function(Trigger trigger)? triggerRegisterer;

  _TaskRunnerImpl({required this.runner, this.triggerRegisterer});

  @override
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route) async {
    return await runner(task, route);
  }

  @override
  Future onRegisterTrigger(Trigger trigger) async {
    await triggerRegisterer?.call(trigger);
  }
}

abstract class TaskRunnerWrapper implements TaskRunner {
  TaskRunner get taskRunner;
}

mixin IsTaskRunnerWrapper implements TaskRunnerWrapper {
  @override
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route) => taskRunner.onRun(task, route);

  @override
  Future onRegisterTrigger(Trigger trigger) => taskRunner.onRegisterTrigger(trigger);
}

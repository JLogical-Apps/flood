import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/local/local_task_runner.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/trigger/trigger.dart';

abstract class TaskRunner {
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route);

  Future onRegisterTrigger(Trigger trigger);

  static final TaskRunnerStatic static = TaskRunnerStatic();
}

class TaskRunnerStatic {
  TaskRunner get local => LocalTaskRunner();
}

extension TaskRunnerExtensions on TaskRunner {
  Future<O> run<T extends Task<R, O>, R extends Route, O>(T task, R route) {
    return onRun(task, route);
  }

  Future registerTrigger(Trigger trigger) => onRegisterTrigger(trigger);
}

mixin IsTaskRunner implements TaskRunner {}

abstract class TaskRunnerWrapper implements TaskRunner {
  TaskRunner get taskRunner;
}

mixin IsTaskRunnerWrapper implements TaskRunnerWrapper {
  @override
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route) => taskRunner.onRun(task, route);

  @override
  Future onRegisterTrigger(Trigger trigger) {
    return taskRunner.onRegisterTrigger(trigger);
  }
}

import 'package:task_core/src/local_task_runner.dart';
import 'package:task_core/src/task.dart';

abstract class TaskRunner {
  Future<O> onRun<I, O>(Task<I, O> task, I input);

  Future<void> schedule(Task task);

  Future<void> remove();

  static TaskRunnerStatic get static => TaskRunnerStatic();
}

class TaskRunnerStatic {
  TaskRunner get local => LocalTaskRunner();
}

extension TaskRunnerExtensions on TaskRunner {
  Future<O> run<I, O>(Task<I, O> task, I input) {
    return onRun(task, input);
  }
}

mixin IsTaskRunner implements TaskRunner {
  @override
  Future<void> remove() async {}
}

abstract class TaskRunnerWrapper implements TaskRunner {
  TaskRunner get taskRunner;
}

mixin IsTaskRunnerWrapper implements TaskRunnerWrapper {
  @override
  Future<O> onRun<I, O>(Task<I, O> task, I input) => taskRunner.onRun(task, input);

  @override
  Future<void> schedule(Task task) => taskRunner.schedule(task);

  @override
  Future<void> remove() => taskRunner.remove();
}

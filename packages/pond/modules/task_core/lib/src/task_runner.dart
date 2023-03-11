import 'package:task_core/src/local_task_runner.dart';
import 'package:task_core/src/task.dart';
import 'package:task_core/src/task_request.dart';

abstract class TaskRunner {
  Future<O> onRun<T extends Task<dynamic, O>, O>(T task, TaskRequest taskRequest);

  static TaskRunnerStatic get static => TaskRunnerStatic();
}

class TaskRunnerStatic {
  TaskRunner get local => LocalTaskRunner();
}

extension TaskRunnerExtensions on TaskRunner {
  Future<O> run<T extends Task<dynamic, O>, O>(T task, TaskRequest input) {
    return onRun(task, input);
  }
}

mixin IsTaskRunner implements TaskRunner {}

abstract class TaskRunnerWrapper implements TaskRunner {
  TaskRunner get taskRunner;
}

mixin IsTaskRunnerWrapper implements TaskRunnerWrapper {
  @override
  Future<O> onRun<T extends Task<dynamic, O>, O>(T task, TaskRequest input) => taskRunner.onRun(task, input);
}

import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/local/local_task_runner.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_request.dart';
import 'package:task_core/src/trigger/trigger.dart';

abstract class TaskRunner {
  Future<O> onRun<T extends Task<dynamic, O>, O>(T task, TaskRequest taskRequest);

  Future onRegisterTrigger(Trigger trigger);

  static TaskRunnerStatic get static => TaskRunnerStatic();
}

class TaskRunnerStatic {
  TaskRunner get local => LocalTaskRunner();
}

extension TaskRunnerExtensions on TaskRunner {
  Future<O> run<T extends Task<dynamic, O>, O>(T task, TaskRequest input) {
    return onRun(task, input);
  }

  Future<O> runTask<T extends Task<dynamic, O>, O>(T task) {
    final definition = task as Task<T, O>;
    return run(task, TaskRequest(path: definition.uri.toString()));
  }

  Future registerTrigger(Trigger trigger) => onRegisterTrigger(trigger);
}

mixin IsTaskRunner implements TaskRunner {}

abstract class TaskRunnerWrapper implements TaskRunner {
  TaskRunner get taskRunner;
}

mixin IsTaskRunnerWrapper implements TaskRunnerWrapper {
  @override
  Future<O> onRun<T extends Task<dynamic, O>, O>(T task, TaskRequest input) => taskRunner.onRun(task, input);

  @override
  Future onRegisterTrigger(Trigger trigger) {
    return taskRunner.onRegisterTrigger(trigger);
  }
}
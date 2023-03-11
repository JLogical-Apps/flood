import 'package:path_core/path_core.dart';
import 'package:task_core/src/task_request.dart';
import 'package:task_core/src/task_runner.dart';

abstract class Task<T extends Task<dynamic, O>, O> with IsRoute<T>, IsPathDefinitionWrapper {
  String get name;

  Future<O> onRun();
}

mixin IsTask<T extends Task<dynamic, O>, O> implements Task<T, O> {}

extension TaskExtensions<T extends Task<dynamic, O>, O> on Task<T, O> {
  Future<O> executeOn({required TaskRunner taskRunner, required TaskRequest input}) {
    return taskRunner.run(this, input);
  }
}

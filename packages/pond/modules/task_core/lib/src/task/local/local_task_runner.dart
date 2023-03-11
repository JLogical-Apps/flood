import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/local/local_trigger_wrapper.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_request.dart';
import 'package:task_core/src/task/task_runner.dart';
import 'package:task_core/src/trigger/trigger.dart';

class LocalTaskRunner with IsTaskRunner {
  @override
  Future<O> onRun<T extends Task<dynamic, O>, O>(T task, TaskRequest input) async {
    final definition = task as Task<T, O>;
    final instance = definition.fromPath(input.path);
    return await instance.onRun();
  }

  @override
  Future onRegisterTrigger(Trigger trigger) async {
    LocalTriggerWrapper.triggerWrapperResolver.resolveOrNull(trigger)?.onRegister(trigger);
  }
}

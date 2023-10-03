import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/local/local_trigger_modifier.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_runner.dart';
import 'package:task_core/src/trigger/trigger.dart';

class LocalTaskRunner with IsTaskRunner {
  @override
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route) async {
    return await task.onRun(route);
  }

  @override
  Future onRegisterTrigger(Trigger trigger) async {
    LocalTriggerModifier.triggerWrapperResolver.resolveOrNull(trigger)?.onRegister(trigger);
  }
}

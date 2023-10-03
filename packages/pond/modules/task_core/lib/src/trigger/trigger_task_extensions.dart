import 'package:path_core/path_core.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_runner.dart';
import 'package:task_core/src/trigger/cron_trigger.dart';

extension TriggerTaskExtensions<R extends Route, T> on Task<R, T> {
  CronTrigger cron({required String cron, required TaskRunner taskRunner, required R route}) {
    return CronTrigger(cron: cron, runner: (time) => executeOn(taskRunner: taskRunner, route: route));
  }
}

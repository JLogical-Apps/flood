import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_runner.dart';
import 'package:task_core/src/trigger/cron_trigger.dart';

extension TriggerTaskExtensions on Task {
  CronTrigger cron({required String cron, required TaskRunner taskRunner}) {
    return CronTrigger(cron: cron, runner: (time) => executeOn(taskRunner: taskRunner));
  }
}

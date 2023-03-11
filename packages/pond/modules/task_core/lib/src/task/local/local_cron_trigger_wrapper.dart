import 'package:cron/cron.dart';
import 'package:task_core/src/task/local/local_trigger_wrapper.dart';
import 'package:task_core/src/trigger/cron_trigger.dart';
import 'package:task_core/src/trigger/trigger.dart';

class LocalCronTriggerWrapper extends LocalTriggerWrapper<CronTrigger> {
  @override
  Future onRegister(Trigger trigger) async {
    trigger as CronTrigger;
    Cron().schedule(Schedule.parse(trigger.cron), () => trigger.trigger(DateTime.now()));
  }
}

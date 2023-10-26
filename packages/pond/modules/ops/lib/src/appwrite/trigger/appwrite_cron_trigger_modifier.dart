import 'package:ops/src/appwrite/trigger/appwrite_trigger_modifier.dart';
import 'package:task_core/task_core.dart';

class AppwriteCronTriggerModifier extends AppwriteTriggerModifier<CronTrigger> {
  @override
  Future onRun(CronTrigger trigger) async {
    await trigger.trigger(DateTime.now());
  }

  @override
  String? getSchedule(CronTrigger trigger) {
    return trigger.cron;
  }
}

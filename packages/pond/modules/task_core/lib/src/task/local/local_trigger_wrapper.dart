import 'package:task_core/src/task/local/local_cron_trigger_wrapper.dart';
import 'package:task_core/src/trigger/trigger.dart';
import 'package:utils_core/utils_core.dart';

abstract class LocalTriggerWrapper<T extends Trigger> with IsTypedWrapper<T, Trigger> {
  Future onRegister(Trigger trigger);

  static Resolver<Trigger, LocalTriggerWrapper> triggerWrapperResolver = Resolver.fromWrappers([
    LocalCronTriggerWrapper(),
  ]);
}

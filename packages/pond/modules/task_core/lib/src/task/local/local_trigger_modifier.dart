import 'package:task_core/src/task/local/local_cron_trigger_modifier.dart';
import 'package:task_core/src/trigger/trigger.dart';
import 'package:utils_core/utils_core.dart';

abstract class LocalTriggerModifier<T extends Trigger> with IsTypedModifier<T, Trigger> {
  Future onRegister(Trigger trigger);

  static Resolver<Trigger, LocalTriggerModifier> triggerWrapperResolver = Resolver.fromModifiers([
    LocalCronTriggerModifier(),
  ]);
}

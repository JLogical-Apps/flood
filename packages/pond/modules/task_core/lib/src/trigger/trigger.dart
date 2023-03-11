import 'dart:async';

import 'package:task_core/src/trigger/cron_trigger.dart';

abstract class Trigger<C> {
  FutureOr onTrigger(C context);

  static TriggerStatic get static => TriggerStatic();
}

extension TriggerExtensions<C> on Trigger<C> {
  FutureOr trigger(C context) => onTrigger(context);
}

class TriggerStatic {
  CronTrigger cron(String cron, FutureOr Function(DateTime time) runner) => CronTrigger(cron: cron, runner: runner);
}

mixin IsTrigger<C> implements Trigger<C> {}

abstract class TriggerWrapper<C> implements Trigger<C> {
  Trigger<C> get trigger;
}

mixin IsTriggerWrapper<C> implements TriggerWrapper<C> {
  @override
  FutureOr onTrigger(C context) {
    return trigger.onTrigger(context);
  }
}

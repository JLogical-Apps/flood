import 'dart:async';

import 'package:task_core/src/trigger/trigger.dart';

class CronTrigger with IsTrigger<DateTime> {
  @override
  final String name;

  final String cron;
  final FutureOr Function(DateTime time) runner;

  CronTrigger({required this.name, required this.cron, required this.runner});

  @override
  FutureOr onTrigger(DateTime context) {
    return runner(context);
  }
}

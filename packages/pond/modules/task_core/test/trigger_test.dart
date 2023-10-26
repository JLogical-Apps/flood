import 'dart:async';

import 'package:task_core/task_core.dart';
import 'package:test/test.dart';

void main() {
  test('cron trigger', () async {
    final taskRunner = TaskRunner.static.local;
    final completer = Completer();
    final cronTrigger = Trigger.static.cron(
      name: 'test',
      cron: '* * * * * *',
      runner: (time) => completer.complete(),
    );
    await taskRunner.registerTrigger(cronTrigger);
    await completer.future;
  });
}

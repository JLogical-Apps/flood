import 'dart:async';

import 'package:actions_core/actions_core.dart';
import 'package:cron/cron.dart' as cron;
import 'package:path_core/path_core.dart';
import 'package:task_core/src/task_schedule.dart';
import 'package:task_core/task_core.dart';
import 'package:test/test.dart';

void main() {
  test('local task runner', () async {
    final taskRunner = TaskRunner.static.local;
    final echoTask = Task(
      action: Action(
        name: 'echo',
        runner: (value) => value,
      ),
      pathDefinition: PathDefinition.string('echo'),
    );
    expect(await echoTask.executeOn(taskRunner: taskRunner, input: 'Hello World!'), 'Hello World!');
  });

  test('local task runner cron', () async {
    final taskRunner = TaskRunner.static.local;
    final completer = Completer();
    final incrementTask = Task(
      action: Action(
        name: 'increment',
        runner: (_) => completer.complete(),
      ),
      pathDefinition: PathDefinition.string('increment'),
    ).withSchedule(TaskSchedule(
      inputGetter: () => null,
      schedule: cron.Schedule.parse('* * * * * *'),
    ));

    taskRunner.schedule(incrementTask);

    await completer.future;

    taskRunner.remove();
  });
}

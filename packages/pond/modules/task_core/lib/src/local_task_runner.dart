import 'package:cron/cron.dart' as cron;
import 'package:task_core/src/task.dart';
import 'package:task_core/src/task_runner.dart';

class LocalTaskRunner with IsTaskRunner {
  final List<cron.ScheduledTask> scheduledTasks = [];

  @override
  Future<O> onRun<I, O>(Task<I, O> task, I input) async {
    return await task.action.run(input);
  }

  @override
  Future<void> schedule(Task task) async {
    final taskSchedule = task.schedule ?? (throw Exception('No cron on task [$task] to schedule!'));

    final scheduledTask = cron.Cron().schedule(taskSchedule.schedule, () => run(task, taskSchedule.input));
    scheduledTasks.add(scheduledTask);
  }

  @override
  Future<void> remove() async {
    for (var scheduledTask in scheduledTasks) {
      scheduledTask.cancel();
    }
    scheduledTasks.clear();
  }
}

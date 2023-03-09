import 'package:task_core/src/task.dart';
import 'package:task_core/src/task_schedule.dart';

class ScheduledTask<I, O> with IsTaskWrapper<I, O> {
  @override
  final Task<I, O> task;

  @override
  final TaskSchedule schedule;

  ScheduledTask({required this.task, required this.schedule});
}

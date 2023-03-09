import 'package:actions_core/actions_core.dart';
import 'package:path_core/path_core.dart';
import 'package:task_core/src/scheduled_task.dart';
import 'package:task_core/src/task_runner.dart';
import 'package:task_core/src/task_schedule.dart';

abstract class Task<I, O> {
  Action<I, O> get action;

  PathDefinition get pathDefinition;

  TaskSchedule? get schedule;

  factory Task({
    required Action<I, O> action,
    required PathDefinition pathDefinition,
    TaskSchedule? schedule,
  }) =>
      _TaskImpl(
        action: action,
        pathDefinition: pathDefinition,
        schedule: schedule,
      );
}

mixin IsTask<I, O> implements Task<I, O> {}

class _TaskImpl<I, O> with IsTask<I, O> {
  @override
  final Action<I, O> action;

  @override
  final PathDefinition pathDefinition;

  @override
  final TaskSchedule? schedule;

  _TaskImpl({required this.action, required this.pathDefinition, this.schedule});
}

extension TaskExtensions<I, O> on Task<I, O> {
  Task<I, O> withSchedule(TaskSchedule schedule) {
    return ScheduledTask(task: this, schedule: schedule);
  }

  Future<O> executeOn({required TaskRunner taskRunner, required I input}) {
    return taskRunner.run(this, input);
  }
}

abstract class TaskWrapper<I, O> implements Task<I, O> {
  Task<I, O> get task;
}

mixin IsTaskWrapper<I, O> implements TaskWrapper<I, O> {
  @override
  Action<I, O> get action => task.action;

  @override
  PathDefinition get pathDefinition => task.pathDefinition;

  @override
  TaskSchedule? get schedule => task.schedule;
}

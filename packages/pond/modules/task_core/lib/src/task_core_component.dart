import 'package:pond_core/pond_core.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_runner.dart';

class TaskCoreComponent with IsCorePondComponent, IsTaskRunnerWrapper {
  final List<Task> tasks;

  @override
  final TaskRunner taskRunner;

  TaskCoreComponent({required this.tasks, required this.taskRunner});
}

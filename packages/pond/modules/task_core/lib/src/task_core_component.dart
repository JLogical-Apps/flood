import 'package:path_core/path_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:task_core/src/task/task.dart';
import 'package:task_core/src/task/task_runner.dart';
import 'package:task_core/src/trigger/trigger.dart';

class TaskCoreComponent with IsCorePondComponent, IsTaskRunnerWrapper {
  @override
  final TaskRunner taskRunner;

  final Map<Route, Task> tasks;
  final List<Trigger> triggers;

  TaskCoreComponent({required this.taskRunner, Map<Route, Task>? tasks, List<Trigger>? triggers})
      : tasks = tasks ?? {},
        triggers = [] {
    if (triggers != null) {
      for (var trigger in triggers) {
        registerTrigger(trigger);
      }
    }
  }

  void registerTask({required Route route, required Task task}) {
    tasks[route] = task;
  }

  void registerTrigger(Trigger trigger) {
    triggers.add(trigger);
    taskRunner.registerTrigger(trigger);
  }
}

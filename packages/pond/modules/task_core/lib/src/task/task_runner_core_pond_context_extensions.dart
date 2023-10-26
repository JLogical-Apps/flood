import 'package:collection/collection.dart';
import 'package:path_core/path_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:task_core/src/task/task_runner.dart';
import 'package:task_core/src/task_core_component.dart';
import 'package:utils_core/utils_core.dart';

extension TaskRunnerCorePondContextExtensions on CorePondContext {
  TaskCoreComponent get taskCoreComponent => locate<TaskCoreComponent>();

  Future<dynamic> runTask(Route route) async {
    final matchingTask = taskCoreComponent.tasks.entries.firstWhereOrNull((entry) {
          final routeBlueprint = entry.key;
          return routeBlueprint.template == route.template;
        })?.value ??
        (throw Exception('Could not find matching route in TaskCoreComponent for [$route]'));

    return await taskCoreComponent.runTask(matchingTask, route);
  }
}

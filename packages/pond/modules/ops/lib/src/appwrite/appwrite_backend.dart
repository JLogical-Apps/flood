import 'package:collection/collection.dart';
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/appwrite/appwrite_backend_context.dart';
import 'package:ops/src/appwrite/trigger/appwrite_trigger_modifier.dart';
import 'package:path_core/path_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:task_core/task_core.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteBackend {
  static Future<dynamic> handle({required CorePondContext corePondContext, required dynamic context}) async {
    final backendContext = AppwriteBackendContext(context: context);

    final triggerName = await corePondContext.environmentCoreComponent.getOrNull('TRIGGER_NAME');
    if (triggerName != null) {
      return await _handleTrigger(
        corePondContext: corePondContext,
        backendContext: backendContext,
        triggerName: triggerName,
      );
    } else {
      return await _handleRequest(
        corePondContext: corePondContext,
        backendContext: backendContext,
      );
    }
  }

  static Future<void> _handleTrigger({
    required CorePondContext corePondContext,
    required AppwriteBackendContext backendContext,
    required String triggerName,
  }) async {
    final taskComponent = corePondContext.locate<TaskCoreComponent>();
    final trigger = taskComponent.triggers.firstWhereOrNull((trigger) => trigger.name == triggerName);
    if (trigger == null) {
      return backendContext.error('Could not find trigger with name [$triggerName]');
    }

    await AppwriteTriggerModifier.getModifier(trigger).onRun(trigger);

    return backendContext.ok('Trigger run successfully!');
  }

  static Future<void> _handleRequest({
    required CorePondContext corePondContext,
    required AppwriteBackendContext backendContext,
  }) async {
    final routeData = RouteData(
      uri: Uri.parse(backendContext.path),
      hiddenState: backendContext.headers,
    );

    final taskComponent = corePondContext.locate<TaskCoreComponent>();
    for (final (route, task) in taskComponent.tasks.entryRecords) {
      if (route.matchesRouteData(routeData)) {
        final instance = route.fromRouteData(routeData) as Route<Route<dynamic>>;
        final result = await task.onRun(instance);
        return backendContext.ok(result);
      }
    }

    return backendContext.error('No route found for ${routeData.uri.toString()}');
  }
}

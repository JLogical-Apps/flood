import 'package:ops/src/appwrite/appwrite_backend_context.dart';
import 'package:path_core/path_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:task_core/task_core.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteServe {
  static Future<dynamic> serve({required CorePondContext corePondContext, required dynamic context}) async {
    final backendContext = AppwriteBackendContext(context: context);

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

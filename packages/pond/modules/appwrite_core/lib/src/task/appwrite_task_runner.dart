import 'package:appwrite_core/src/appwrite_consts.dart';
import 'package:appwrite_core/src/appwrite_core_component.dart';
import 'package:path_core/path_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:task_core/task_core.dart';
import 'package:utils_core/utils_core.dart';

extension AppwriteTaskRunnerExtensions on TaskRunnerStatic {
  TaskRunner appwrite(CorePondContext context) => TaskRunner(
        runner: <T extends Task<R, O>, R extends Route, O>(task, route) async {
          final appwriteComponent = context.locate<AppwriteCoreComponent>();
          final execution = await appwriteComponent.functions.createExecution(
            functionId: AppwriteConsts.taskFunctionName,
            path: route.uri.toString(),
            xasync: false,
          );

          if (execution.responseStatusCode.toString().startsWith('2')) {
            return coerce<O>(execution.responseBody);
          } else {
            throw Exception('Error in response! \n${execution.responseBody}');
          }
        },
      );
}

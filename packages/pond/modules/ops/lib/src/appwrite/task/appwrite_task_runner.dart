import 'package:appwrite_core/appwrite_core.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:ops/src/appwrite/util/appwrite_core_component_extensions.dart';
import 'package:path_core/path_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:task_core/task_core.dart';
import 'package:utils_core/utils_core.dart';

extension AppwriteTaskRunnerExtensions on TaskRunnerStatic {
  TaskRunner appwrite(CorePondContext context) => _AppwriteTaskRunner(client: context.client);
}

class _AppwriteTaskRunner with IsTaskRunner {
  final Client client;

  late final Functions functions = Functions(client);

  _AppwriteTaskRunner({required this.client});

  @override
  Future onRegisterTrigger(Trigger trigger) async {}

  @override
  Future<O> onRun<T extends Task<R, O>, R extends Route, O>(T task, R route) async {
    final execution = await functions.createExecution(
      functionId: AppwriteConsts.taskFunctionName,
      path: route.uri.toString(),
      xasync: false,
    );

    if (execution.responseStatusCode.toString().startsWith('2')) {
      return coerce<O>(execution.responseBody);
    } else {
      throw Exception('Error in response! \n${execution.responseBody}');
    }
  }
}

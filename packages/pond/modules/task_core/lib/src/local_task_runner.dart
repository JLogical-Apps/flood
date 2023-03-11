import 'package:path_core/path_core.dart';
import 'package:task_core/src/task.dart';
import 'package:task_core/src/task_request.dart';
import 'package:task_core/src/task_runner.dart';

class LocalTaskRunner with IsTaskRunner {
  @override
  Future<O> onRun<T extends Task<dynamic, O>, O>(T task, TaskRequest input) async {
    final definition = task as Task<T, O>;
    final instance = definition.fromPath(input.path);
    return await instance.onRun();
  }
}

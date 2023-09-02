import 'package:path_core/path_core.dart';
import 'package:task_core/task_core.dart';
import 'package:test/test.dart';

void main() {
  test('local task runner', () async {
    final taskRunner = TaskRunner.static.local;
    expect(
      await taskRunner.run(
          EchoTask(),
          TaskRequest(
            path: Uri(pathSegments: ['echo', 'Hello World!']).toString(),
          )),
      'Hello World!',
    );

    expect(
      await (EchoTask()..echoField.set('Hey!')).executeOn(taskRunner: taskRunner),
      'Hey!',
    );
  });
}

class EchoTask with IsTask<EchoTask, String>, IsRoute<EchoTask>, IsPathDefinitionWrapper {
  late final echoField = field<String>(name: 'input').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('echo').property(echoField);

  @override
  EchoTask copy() {
    return EchoTask();
  }

  @override
  String get name => 'echo';

  @override
  Future<String> onRun() async {
    return echoField.value;
  }
}

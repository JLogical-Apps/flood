import 'package:path_core/path_core.dart';
import 'package:task_core/task_core.dart';
import 'package:test/test.dart';

void main() {
  test('local task runner', () async {
    final taskRunner = TaskRunner.static.local;
    final echoTask = Task(runner: (EchoRoute route) => route.echoField.value);
    expect(
      await taskRunner.runTask(
        echoTask,
        EchoRoute()..echoField.set('Hello World!'),
      ),
      'Hello World!',
    );

    expect(
      await echoTask.executeOn(
        taskRunner: taskRunner,
        route: EchoRoute()..echoField.set('Hey!'),
      ),
      'Hey!',
    );
  });
}

class EchoRoute with IsRoute<EchoRoute> {
  late final echoField = field<String>(name: 'input').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('echo').property(echoField);

  @override
  EchoRoute copy() {
    return EchoRoute();
  }
}

import 'package:actions_core/actions_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('actions registered', () async {
    var startCount = 0;
    var finishCount = 0;
    var errorCount = 0;
    String? lastOutput;

    final actionCoreComponent = ActionCoreComponent(
      actions: [
        echoAction.withAdditionalSetup(
          onCall: (parameters) => startCount++,
          onCalled: (parameters, output) {
            finishCount++;
            lastOutput = output;
          },
          onFailed: (parameters, e, stackTrace) => errorCount++,
        ),
      ],
    );

    final corePondContext = CorePondContext();
    await corePondContext.register(actionCoreComponent);

    final output = await echoAction.run('Hello World');
    expect(output, 'Hello World');
    expect(startCount, 1);
    expect(finishCount, 1);
    expect(lastOutput, 'Hello World');
  });
}

final echoAction = Action<String?, String>.fromRunner(
    name: 'echo', runner: (input) => input ?? (throw Exception('Input cannot be null!')));

import 'package:actions_core/actions_core.dart';
import 'package:actions_core/src/action_context.dart';
import 'package:actions_core/src/action_runner.dart';
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
        EchoAction().withAdditionalSetup(
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

    final output = await actionCoreComponent.findAction<EchoAction, String?, String>().run('Hello World');
    expect(output, 'Hello World');
    expect(startCount, 1);
    expect(finishCount, 1);
    expect(lastOutput, 'Hello World');
  });
}

class EchoAction with IsAction<String?, String> {
  @override
  String get name => 'Echo';

  @override
  ActionRunner<String?, String> get actionRunner =>
      ActionRunner(runner: (String? input) => input ?? (throw Exception('Input cannot be null!')));
}

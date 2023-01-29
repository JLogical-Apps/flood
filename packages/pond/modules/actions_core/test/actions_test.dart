import 'package:actions_core/src/action.dart';
import 'package:actions_core/src/action_runner.dart';
import 'package:test/test.dart';

void main() {
  test('actions', () async {
    final action = EchoAction();
    final output = await action('3');
    expect(output, '3');
  });

  test('actions with listeners', () async {
    var startCount = 0;
    var finishCount = 0;
    var errorCount = 0;
    String? lastOutput;
    final action = EchoAction().withAdditionalSetup(
      onCall: (parameters) => startCount++,
      onCalled: (parameters, output) {
        finishCount++;
        lastOutput = output;
      },
      onFailed: (parameters, e, stackTrace) => errorCount++,
    );

    final output = await action('Hello World');
    expect(output, 'Hello World');
    expect(startCount, 1);
    expect(finishCount, 1);
    expect(lastOutput, 'Hello World');

    expect(() => action(null), throwsA(isA<Exception>()));
    expect(startCount, 2);
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

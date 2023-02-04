import 'package:log_core/log_core.dart';
import 'package:test/test.dart';

void main() {
  test('log', () async {
    final logCoreComponent = LogCoreComponent.console();
    await logCoreComponent.log('Hello World');
    await logCoreComponent.logWarning('Hello World');
    await logCoreComponent.logError('Hello World', StackTrace.current);

    expect(await logCoreComponent.getLogs(), startsWith('Hello World\n[WARNING] Hello World\n[ERROR] Hello World'));
  });
}

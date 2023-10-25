import 'package:log_core/log_core.dart';
import 'package:test/test.dart';

void main() {
  test('log', () async {
    final logCoreComponent = LogCoreComponent(loggerService: LoggerService.static.console);
    await logCoreComponent.log('Hello World');
    await logCoreComponent.logWarning('Hello World');
    await logCoreComponent.logError('Hello World', StackTrace.current);

    expect(await logCoreComponent.getLogs(), [
      'Hello World',
      '[WARNING] Hello World',
      startsWith('[ERROR] Hello World'),
    ]);
  });
}

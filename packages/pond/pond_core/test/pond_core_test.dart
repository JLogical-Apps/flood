import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';

void main() {
  test('registering a component allows you to locate it.', () {
    final testPondComponent = TestPondComoponent();
    final corePondContext = CorePondContext()..register(testPondComponent);
    expect(corePondContext.resolveOrNull<TestPondComoponent>(), testPondComponent);
  });
}

class TestPondComoponent extends CorePondComponent {}

import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('registering a component allows you to locate it.', () {
    final testPondComponent = TestPondComponent();
    final corePondContext = CorePondContext()..register(testPondComponent);
    expect(corePondContext.resolveTypeOrNull<TestPondComponent>(), testPondComponent);
  });
}

class TestPondComponent extends CorePondComponent {}

import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('locator', () {
    final locator = Locator()
      ..register(1)
      ..register(3.14)
      ..register(false)
      ..register('hello world');

    expect(locator.locate<int>(), 1);
    expect(locator.locate<double>(), 3.14);
    expect(locator.locate<bool>(), false);
    expect(locator.locate<String>(), 'hello world');
  });
}

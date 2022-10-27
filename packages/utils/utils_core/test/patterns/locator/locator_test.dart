import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('basic locator', () {
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

  test('onLocate', () {
    var objectCount = 0;
    Locator(onRegistered: (_) => objectCount++)
      ..register(1)
      ..register(2)
      ..register(3);

    expect(objectCount, 3);
  });

  test('expand', () {
    const boolValue = false;
    const intValue = 1;
    const stringValue = 'test';
    final locator = Locator().expand((object) => [object, boolValue])
      ..register(intValue)
      ..register(stringValue);

    expect(locator.locate<bool>(), boolValue);
    expect(locator.locate<int>(), intValue);
    expect(locator.locate<String>(), stringValue);
  });
}

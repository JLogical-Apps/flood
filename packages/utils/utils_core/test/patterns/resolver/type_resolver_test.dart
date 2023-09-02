import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('type resolver', () {
    const elements = [1, 3.14, false, 'hello world'];
    final typeResolver = Resolver.byType(elements);

    for (final element in elements) {
      expect(typeResolver.resolve(element.runtimeType), element);
    }
  });
}

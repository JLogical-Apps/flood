import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('basic resolver functionality', () {
    final nameByNumberResolver = getNameByNumberResolver();

    expect(nameByNumberResolver.resolveOrNull(1), 'one');
    expect(nameByNumberResolver.resolveOrNull(2), 'two');

    const invalidInput = -1;
    expect(nameByNumberResolver.resolveOrNull(invalidInput), null);
    expect(() => nameByNumberResolver.resolve(invalidInput), throwsA(isA<Exception>()));
  });
}

Resolver<int, String> getNameByNumberResolver() {
  final nameByNumber = {
    1: 'one',
    2: 'two',
    3: 'three',
  };

  return Resolver.fromMap(nameByNumber);
}

import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('modifier resolver', () {
    final modifierResolver = Resolver.fromModifiers<AbstractTypeModifier, dynamic>([
      IntTypeModifier(),
      StringTypeModifier(),
      BoolTypeModifier(),
    ]);

    expect(modifierResolver.resolve(0).numValue(0), 0);
    expect(modifierResolver.resolve('test').numValue('test'), 4);
    expect(modifierResolver.resolve(true).numValue(true), 1);
  });
}

abstract class AbstractTypeModifier<I> extends Modifier<dynamic> {
  @override
  bool shouldModify(input) {
    return input is I;
  }

  int numValue(input);
}

class IntTypeModifier extends AbstractTypeModifier<int> {
  @override
  int numValue(input) {
    return input as int;
  }
}

class StringTypeModifier extends AbstractTypeModifier<String> {
  @override
  int numValue(input) {
    return (input as String).length;
  }
}

class BoolTypeModifier extends AbstractTypeModifier<bool> {
  @override
  int numValue(input) {
    return (input as bool) ? 1 : 0;
  }
}

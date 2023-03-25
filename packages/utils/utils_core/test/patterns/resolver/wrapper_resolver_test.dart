import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('wrapper resolver', () {
    final wrapperResolver = Resolver.fromModifiers<AbstractTypeWrapper, dynamic>([
      IntTypeWrapper(),
      StringTypeWrapper(),
      BoolTypeWrapper(),
    ]);

    expect(wrapperResolver.resolve(0).numValue(0), 0);
    expect(wrapperResolver.resolve('test').numValue('test'), 4);
    expect(wrapperResolver.resolve(true).numValue(true), 1);
  });
}

abstract class AbstractTypeWrapper<I> extends Modifier<dynamic> {
  @override
  bool shouldModify(input) {
    return input is I;
  }

  int numValue(input);
}

class IntTypeWrapper extends AbstractTypeWrapper<int> {
  @override
  int numValue(input) {
    return input as int;
  }
}

class StringTypeWrapper extends AbstractTypeWrapper<String> {
  @override
  int numValue(input) {
    return (input as String).length;
  }
}

class BoolTypeWrapper extends AbstractTypeWrapper<bool> {
  @override
  int numValue(input) {
    return (input as bool) ? 1 : 0;
  }
}

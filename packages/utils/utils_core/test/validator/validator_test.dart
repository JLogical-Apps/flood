import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('basic validator test', () async {
    final validator = Validator.isNotNull();
    expect(await validator.validate(null), isA<Exception>());
    expect(await validator.validate(1), isNull);
  });

  test('compound validator test', () async {
    final validator = Validator.isNotNull() + Validator.isGreaterThan(0);
    expect(await validator.validate(null), isA<Exception>());
    expect(await validator.validate(0), isA<Exception>());
    expect(await validator.validate(1), isNull);
  });

  test('equals test', () async {
    final isZeroValidator = Validator.isEqualTo(0);
    expect(await isZeroValidator.validate(0), isNull);
    expect(await isZeroValidator.validate(null), isNull);
    expect(await isZeroValidator.validate(1), isA<Exception>());

    final isNotZeroValidator = Validator.isNotEqualTo(0);
    expect(await isNotZeroValidator.validate(1), isNull);
    expect(await isNotZeroValidator.validate(null), isNull);
    expect(await isNotZeroValidator.validate(0), isA<Exception>());
  });

  test('numeric validation', () async {
    final isPositive = Validator.isPositive();
    final isNegative = Validator.isNegative();
    final isNonNegative = Validator.isNonNegative();
    final isNonPositive = Validator.isNonPositive();

    expect(await isPositive.validate(-1), isA<Exception>());
    expect(await isNegative.validate(-1), isNull);
    expect(await isNonNegative.validate(-1), isA<Exception>());
    expect(await isNonPositive.validate(-1), isNull);

    expect(await isPositive.validate(0), isA<Exception>());
    expect(await isNegative.validate(0), isA<Exception>());
    expect(await isNonNegative.validate(0), isNull);
    expect(await isNonPositive.validate(0), isNull);

    expect(await isPositive.validate(1), isNull);
    expect(await isNegative.validate(1), isA<Exception>());
    expect(await isNonNegative.validate(1), isNull);
    expect(await isNonPositive.validate(1), isA<Exception>());
  });

  test('string validation', () async {
    final isNotBlank = Validator.isNotBlank();
    expect(await isNotBlank.validate(null), isA<Exception>());
    expect(await isNotBlank.validate(' '), isA<Exception>());
    expect(await isNotBlank.validate('test'), isNull);

    final isEmail = Validator.isEmail();
    expect(await isEmail.validate('test@test.com'), isNull);
    expect(await isEmail.validate('t@t.t'), isNull);
    expect(await isEmail.validate('tt.t'), isA<Exception>());

    final isInt = Validator.isInt();
    final isDouble = Validator.isDouble();
    expect(await isInt.validate('1'), isNull);
    expect(await isDouble.validate('1'), isNull);
    expect(await isInt.validate('3.14'), isA<Exception>());
    expect(await isDouble.validate('3.14'), isNull);
  });
}

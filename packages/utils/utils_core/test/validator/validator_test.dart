import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('basic validator test', () async {
    final validator = Validator.isNotNull();
    expect(await validator.validate(null), isNotNull);
    expect(await validator.validate(1), isNull);
  });

  test('compound validator test', () async {
    final validator = Validator.isNotNull().mapError<dynamic>((e) => e) + Validator.isGreaterThan(0);
    expect(await validator.validate(null), isNotNull);
    expect(await validator.validate(0), isNotNull);
    expect(await validator.validate(1), isNull);
  });

  test('equals test', () async {
    final isZeroValidator = Validator.isEqualTo(0);
    expect(await isZeroValidator.validate(0), isNull);
    expect(await isZeroValidator.validate(null), isNull);
    expect(await isZeroValidator.validate(1), isNotNull);

    final isNotZeroValidator = Validator.isNotEqualTo(0);
    expect(await isNotZeroValidator.validate(1), isNull);
    expect(await isNotZeroValidator.validate(null), isNull);
    expect(await isNotZeroValidator.validate(0), isNotNull);
  });

  test('numeric validation', () async {
    final isPositive = Validator.isPositive();
    final isNegative = Validator.isNegative();
    final isNonNegative = Validator.isNonNegative();
    final isNonPositive = Validator.isNonPositive();

    expect(await isPositive.validate(-1), isNotNull);
    expect(await isNegative.validate(-1), isNull);
    expect(await isNonNegative.validate(-1), isNotNull);
    expect(await isNonPositive.validate(-1), isNull);

    expect(await isPositive.validate(0), isNotNull);
    expect(await isNegative.validate(0), isNotNull);
    expect(await isNonNegative.validate(0), isNull);
    expect(await isNonPositive.validate(0), isNull);

    expect(await isPositive.validate(1), isNull);
    expect(await isNegative.validate(1), isNotNull);
    expect(await isNonNegative.validate(1), isNull);
    expect(await isNonPositive.validate(1), isNotNull);
  });

  test('string validation', () async {
    final isNotBlank = Validator.isNotBlank();
    expect(await isNotBlank.validate(null), isNotNull);
    expect(await isNotBlank.validate(' '), isNotNull);
    expect(await isNotBlank.validate('test'), isNull);

    final isEmail = Validator.isEmail();
    expect(await isEmail.validate('test@test.com'), isNull);
    expect(await isEmail.validate('t@t.t'), isNull);
    expect(await isEmail.validate('tt.t'), isNotNull);

    expect(await Validator.minLength(4).validate(null), isNull);
    expect(await Validator.minLength(4).validate('1'), isNotNull);
    expect(await Validator.minLength(4).validate('1234'), isNull);
    expect(await Validator.minLength(4).validate('12345'), isNull);

    expect(await Validator.maxLength(4).validate(null), isNull);
    expect(await Validator.maxLength(4).validate('1'), isNull);
    expect(await Validator.maxLength(4).validate('1234'), isNull);
    expect(await Validator.maxLength(4).validate('12345'), isNotNull);

    final isInt = Validator.isInt();
    final isDouble = Validator.isDouble();
    expect(await isInt.validate('1'), isNull);
    expect(await isDouble.validate('1'), isNull);
    expect(await isInt.validate('3.14'), isNotNull);
    expect(await isDouble.validate('3.14'), isNull);

    final isPhone = Validator.isPhone();
    expect(await isPhone.validate('540-456-7890'), isNull);
    expect(await isPhone.validate('(540) 456-7890'), isNull);
    expect(await isPhone.validate('5404567890'), isNull);
    expect(await isPhone.validate('+15404567890'), isNull);
    expect(await isPhone.validate('+1 888-920-5757'), isNull);
    expect(await isPhone.validate('+44 20 1234 5678'), isNull);
    expect(await isPhone.validate('+49-89-636-48018'), isNull);
    expect(await isPhone.validate('540.456.7890'), isNull);
    expect(await isPhone.validate('(540)-456-7890'), isNull);
    expect(await isPhone.validate('540123123'), isNotNull);
    expect(await isPhone.validate('54045678901'), isNotNull);
    expect(await isPhone.validate('test@test.com'), isNotNull);
    expect(await isPhone.validate('abc'), isNotNull);
    expect(await isPhone.validate('(540)456-7890'), isNull);
    expect(await isPhone.validate('540-456-789'), isNotNull);
    expect(await isPhone.validate('54-3456-7890'), isNotNull);
  });
}

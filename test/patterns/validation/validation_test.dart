import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('different validation techniques.', () async {
    const nonNullObject = 1;

    final validation = Validation.required();

    expect(() => validation.validate(nonNullObject), returnsNormally);
    expect(() => validation.validate(null), throwsA(isA<RequiredValidationException>()));

    expect(await validation.isValid(nonNullObject), isTrue);
    expect(await validation.isValid(null), isFalse);

    expect(await validation.getException(nonNullObject), isNull);
    expect(await validation.getException(null), isA<RequiredValidationException>());
  });

  test('required', () async {
    const nonNullObject = 1;

    final validation = Validation.required();

    expect(() => validation.validate(nonNullObject), returnsNormally);
    expect(() => validation.validate(null), throwsA(isA<RequiredValidationException>()));
  });

  test('min length', () async {
    const empty = '';
    const fiveLetters = 'abcde';
    const minLength = 3;

    final threeLettersMinValidation = Validation.minLength(minLength);

    expect(() => threeLettersMinValidation.validate(empty), throwsA(isA<MinLengthValidationException>()));
    expect(() => threeLettersMinValidation.validate(fiveLetters), returnsNormally);
  });

  test('max length', () async {
    const empty = '';
    const fiveLetters = 'abcde';
    const maxLength = 3;

    final threeLettersMaxValidation = Validation.maxLength(maxLength);

    expect(() => threeLettersMaxValidation.validate(empty), returnsNormally);
    expect(() => threeLettersMaxValidation.validate(fiveLetters), throwsA(isA<MaxLengthValidationException>()));
  });

  test('parsing int', () async {
    const letters = 'abc';
    const intString = '35';
    const doubleString = '12.36';

    final isIntValidation = Validation.isInt();

    expect(() => isIntValidation.validate(letters), throwsA(isA<IsIntValidationException>()));
    expect(() => isIntValidation.validate(intString), returnsNormally);
    expect(() => isIntValidation.validate(doubleString), throwsA(isA<IsIntValidationException>()));
  });

  test('parsing double', () async {
    const letters = 'abc';
    const intString = '35';
    const doubleString = '12.36';

    final isDoubleValidation = Validation.isDouble();

    expect(() => isDoubleValidation.validate(letters), throwsA(isA<IsDoubleValidationException>()));
    expect(() => isDoubleValidation.validate(intString), returnsNormally);
    expect(() => isDoubleValidation.validate(doubleString), returnsNormally);
  });

  test('parsing currency', () async {
    const letters = 'abc';
    const intString = '35';
    const doubleString = '12.36';
    const currencyString = r'$112,212.36';

    final isCurrencyValidation = Validation.isCurrency();

    expect(() => isCurrencyValidation.validate(letters), throwsA(isA<IsCurrencyValidationException>()));
    expect(() => isCurrencyValidation.validate(intString), returnsNormally);
    expect(() => isCurrencyValidation.validate(doubleString), returnsNormally);
    expect(() => isCurrencyValidation.validate(currencyString), returnsNormally);
  });

  test('email', () async {
    const empty = '';
    const letters = 'abc';
    const email = 'a@b.com';

    final isEmailValidation = Validation.isEmail();

    expect(() => isEmailValidation.validate(empty), returnsNormally);
    expect(() => isEmailValidation.validate(letters), throwsA(isA<IsEmailValidationException>()));
    expect(() => isEmailValidation.validate(email), returnsNormally);
  });
}

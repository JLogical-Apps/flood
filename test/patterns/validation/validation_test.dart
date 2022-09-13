import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/phone/is_phone_validation_exception.dart';

void main() {
  test('different validation techniques.', () async {
    const nonNullObject = 1;

    final validator = Validator.required();

    expect(() => validator.validate(nonNullObject), returnsNormally);
    expect(() => validator.validate(null), throwsA(isA<RequiredValidationException>()));

    expect(await validator.isValid(nonNullObject), isTrue);
    expect(await validator.isValid(null), isFalse);

    expect(await validator.getException(nonNullObject), isNull);
    expect(await validator.getException(null), isA<RequiredValidationException>());
  });

  test('required', () async {
    const nonNullObject = 1;
    const emptyString = '';
    const letters = 'abc';
    const emptyList = [];
    const nonEmptyList = [1, 2, 3];

    final validator = Validator.required();

    expect(() => validator.validate(nonNullObject), returnsNormally);
    expect(() => validator.validate(null), throwsA(isA<RequiredValidationException>()));
    expect(() => validator.validate(true), returnsNormally);
    expect(() => validator.validate(false), throwsA(isA<RequiredValidationException>()));
    expect(() => validator.validate(letters), returnsNormally);
    expect(() => validator.validate(emptyString), throwsA(isA<RequiredValidationException>()));
    expect(() => validator.validate(nonEmptyList), returnsNormally);
    expect(() => validator.validate(emptyList), throwsA(isA<RequiredValidationException>()));
  });

  test('min length', () async {
    const empty = '';
    const fiveLetters = 'abcde';
    const minLength = 3;

    final threeLettersMinValidator = Validator.minLength(minLength);

    expect(() => threeLettersMinValidator.validate(empty), throwsA(isA<MinLengthValidationException>()));
    expect(() => threeLettersMinValidator.validate(fiveLetters), returnsNormally);
  });

  test('max length', () async {
    const empty = '';
    const fiveLetters = 'abcde';
    const maxLength = 3;

    final threeLettersMaxValidator = Validator.maxLength(maxLength);

    expect(() => threeLettersMaxValidator.validate(empty), returnsNormally);
    expect(() => threeLettersMaxValidator.validate(fiveLetters), throwsA(isA<MaxLengthValidationException>()));
  });

  test('parsing int', () async {
    const letters = 'abc';
    const intString = '35';
    const doubleString = '12.36';

    final isIntValidator = Validator.isInt();

    expect(() => isIntValidator.validate(letters), throwsA(isA<IsIntValidationException>()));
    expect(() => isIntValidator.validate(intString), returnsNormally);
    expect(() => isIntValidator.validate(doubleString), throwsA(isA<IsIntValidationException>()));
  });

  test('parsing double', () async {
    const letters = 'abc';
    const intString = '35';
    const doubleString = '12.36';

    final isDoubleValidator = Validator.isDouble();

    expect(() => isDoubleValidator.validate(letters), throwsA(isA<IsDoubleValidationException>()));
    expect(() => isDoubleValidator.validate(intString), returnsNormally);
    expect(() => isDoubleValidator.validate(doubleString), returnsNormally);
  });

  test('parsing currency', () async {
    const letters = 'abc';
    const intString = '35';
    const doubleString = '12.36';
    const currencyString = r'$112,212.36';

    final isCurrencyValidator = Validator.isCurrency();

    expect(() => isCurrencyValidator.validate(letters), throwsA(isA<IsCurrencyValidationException>()));
    expect(() => isCurrencyValidator.validate(intString), returnsNormally);
    expect(() => isCurrencyValidator.validate(doubleString), returnsNormally);
    expect(() => isCurrencyValidator.validate(currencyString), returnsNormally);
  });

  test('email', () async {
    const empty = '';
    const letters = 'abc';
    const email = 'a@b.com';

    final isEmailValidator = Validator.isEmail();

    expect(() => isEmailValidator.validate(empty), throwsA(isA<IsEmailValidationException>()));
    expect(() => isEmailValidator.validate(letters), throwsA(isA<IsEmailValidationException>()));
    expect(() => isEmailValidator.validate(email), returnsNormally);
  });

  test('phone', () async {
    const empty = '';
    const letters = 'abc';
    const email = 'a@b.com';
    final validPhoneNumbers = [
      '+15405600100',
      '(540) 560-0100',
      '540-560-0100',
      '+1-540-560-0100',
    ];

    final isPhoneValidator = Validator.isPhoneNumber();

    expect(() => isPhoneValidator.validate(empty), throwsA(isA<IsPhoneValidationException>()));
    expect(() => isPhoneValidator.validate(letters), throwsA(isA<IsPhoneValidationException>()));
    expect(() => isPhoneValidator.validate(email), throwsA(isA<IsPhoneValidationException>()));
    validPhoneNumbers.forEach((phone) => expect(() => isPhoneValidator.validate(phone), returnsNormally));
  });

  test('password', () async {
    const empty = '';
    const threeLetters = 'abc';
    const eightLetters = 'abcdefgh';

    final isPasswordValidator = Validator.isPassword();

    expect(() => isPasswordValidator.validate(empty), throwsA(isA<RequiredValidationException>()));
    expect(() => isPasswordValidator.validate(threeLetters), throwsA(isA<MinLengthValidationException>()));
    expect(() => isPasswordValidator.validate(eightLetters), returnsNormally);
  });

  test('datetime', () async {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));
    final tomorrow = today.add(Duration(days: 1));

    final isAfterTodayValidator = Validator.isAfter(today);

    expect(() => isAfterTodayValidator.validate(yesterday), throwsA(isA<IsAfterValidationException>()));
    expect(() => isAfterTodayValidator.validate(today), throwsA(isA<IsAfterValidationException>()));
    expect(() => isAfterTodayValidator.validate(tomorrow), returnsNormally);

    final isBeforeTodayValidator = Validator.isBefore(today);

    expect(() => isBeforeTodayValidator.validate(yesterday), returnsNormally);
    expect(() => isBeforeTodayValidator.validate(today), throwsA(isA<IsBeforeValidationException>()));
    expect(() => isBeforeTodayValidator.validate(tomorrow), throwsA(isA<IsBeforeValidationException>()));
  });

  test('mapped', () async {
    const listOfValidWords = ['apple', 'banana', 'cashew'];
    const listOfInvalidWords = ['a', 'b', 'c'];
    const minLength = 3;

    final firstWordThreeLettersValidator = Validator.minLength(minLength).map((List list) => list[0]);

    expect(() => firstWordThreeLettersValidator.validate(listOfValidWords), returnsNormally);
    expect(() => firstWordThreeLettersValidator.validate(listOfInvalidWords),
        throwsA(isA<MinLengthValidationException>()));
  });
}

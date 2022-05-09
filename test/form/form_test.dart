import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('initial values.', () {
    final formModel = _getSignupForm();
    expect(formModel['name'], '');
    expect(formModel['email'], '');
    expect(formModel['password'], '');
  });

  test('changing values.', () {
    const name = 'John Doe';
    const email = 'a@b.com';
    const password = 'asdfasdf';

    final formModel = _getSignupForm();

    formModel['name'] = name;
    formModel['email'] = email;
    formModel['password'] = password;

    expect(formModel['name'], name);
    expect(formModel['email'], email);
    expect(formModel['password'], password);
  });

  test('validation', () async {
    const name = 'John Doe';
    const email = 'a@b.com';
    const password = 'asdfasdf';

    final formModel = _getSignupForm();

    formModel['name'] = name;
    formModel['email'] = email;
    formModel['password'] = password;
    formModel['confirmPassword'] = password;

    final result = await formModel.submit();

    expect(result.isValid, isTrue);
    expect(result.data['name'], name);
    expect(result.data['email'], email);
    expect(result.data['password'], password);
    expect(result.data['confirmPassword'], password);
  });

  test('string validation.', () async {
    const empty = '';
    const shortName = 'BJ';
    const name = 'John Doe';

    final nameForm = FormModel(
      fields: [
        StringFormField(name: 'name').required().minLength(4),
      ],
    );

    nameForm['name'] = empty;
    await expectInvalidForm(nameForm);

    nameForm['name'] = shortName;
    await expectInvalidForm(nameForm);

    nameForm['name'] = name;
    await expectValidForm(nameForm);
  });

  test('email validation.', () async {
    const empty = '';
    const email = 'a@b.com';
    const invalidEmail = 'a@';

    final emailForm = FormModel(
      fields: [
        StringFormField(name: 'email').required().isEmail(),
      ],
    );

    emailForm['email'] = empty;
    await expectInvalidForm(emailForm);

    emailForm['email'] = invalidEmail;
    await expectInvalidForm(emailForm);

    emailForm['email'] = email;
    await expectValidForm(emailForm);
  });

  test('parsing int validation.', () async {
    const empty = '';
    const letters = 'abcde';
    const int = '24';
    const double = '12.34';
    const currency = r'$94,241.24';

    final intForm = FormModel(
      fields: [
        StringFormField(name: 'int').required().isInt(),
      ],
    );

    intForm['int'] = empty;
    await expectInvalidForm(intForm);

    intForm['int'] = letters;
    await expectInvalidForm(intForm);

    intForm['int'] = int;
    await expectValidForm(intForm);

    intForm['int'] = double;
    await expectInvalidForm(intForm);

    intForm['int'] = currency;
    await expectInvalidForm(intForm);
  });

  test('parsing double validation.', () async {
    const empty = '';
    const letters = 'abcde';
    const int = '24';
    const double = '12.34';
    const currency = r'$94,241.24';

    final doubleForm = FormModel(
      fields: [
        StringFormField(name: 'double').required().isDouble(),
      ],
    );

    doubleForm['double'] = empty;
    await expectInvalidForm(doubleForm);

    doubleForm['double'] = letters;
    await expectInvalidForm(doubleForm);

    doubleForm['double'] = int;
    await expectValidForm(doubleForm);

    doubleForm['double'] = double;
    await expectValidForm(doubleForm);

    doubleForm['double'] = currency;
    await expectInvalidForm(doubleForm);
  });

  test('parsing currency validation.', () async {
    const empty = '';
    const letters = 'abcde';
    const int = '24';
    const double = '12.34';
    const currency = r'$94,241.24';

    final currencyForm = FormModel(
      fields: [
        StringFormField(name: 'currency').required().isCurrency(),
      ],
    );

    currencyForm['currency'] = empty;
    await expectInvalidForm(currencyForm);

    currencyForm['currency'] = letters;
    await expectInvalidForm(currencyForm);

    currencyForm['currency'] = int;
    await expectValidForm(currencyForm);

    currencyForm['currency'] = double;
    await expectValidForm(currencyForm);

    currencyForm['currency'] = currency;
    await expectValidForm(currencyForm);
  });

  test('password validation.', () async {
    const empty = '';
    const password = 'password';
    const shortPassword = 'pass';
    const unmatchingPassword = r'pa$$w0Rd';

    final passwordForm = FormModel(
      fields: [
        StringFormField(name: 'password').required().isPassword(),
        StringFormField(name: 'confirmPassword').required().isConfirmPassword(),
      ],
    );

    passwordForm['password'] = empty;
    passwordForm['confirmPassword'] = empty;
    await expectInvalidForm(passwordForm);

    passwordForm['password'] = password;
    passwordForm['confirmPassword'] = empty;
    await expectInvalidForm(passwordForm);

    passwordForm['password'] = shortPassword;
    passwordForm['confirmPassword'] = shortPassword;
    await expectInvalidForm(passwordForm);

    passwordForm['password'] = password;
    passwordForm['confirmPassword'] = unmatchingPassword;
    await expectInvalidForm(passwordForm);

    passwordForm['password'] = password;
    passwordForm['confirmPassword'] = password;
    await expectValidForm(passwordForm);
  });

  test('reactivity', () async {
    const name = 'John Doe';

    final formModel = _getSignupForm();

    final completer = Completer();
    formModel.getFieldByName('name').valueX.listen((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    formModel['name'] = name;

    await completer.future;
  });
}

FormModel _getSignupForm() {
  return FormModel(
    fields: [
      StringFormField(name: 'name').required().minLength(4),
      StringFormField(name: 'email').required().isEmail(),
      StringFormField(name: 'password').required().isPassword(),
      StringFormField(name: 'confirmPassword').required().isConfirmPassword(),
    ],
  );
}

Future expectValidForm(FormModel form) async {
  final result = await form.submit();
  expect(result.isValid, isTrue);
}

Future expectInvalidForm(FormModel form) async {
  final result = await form.submit();
  expect(result.isValid, isFalse);
}

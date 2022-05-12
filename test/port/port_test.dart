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

    final nameForm = Port(
      fields: [
        StringPortField(name: 'name').required().minLength(4),
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

    final emailForm = Port(
      fields: [
        StringPortField(name: 'email').required().isEmail(),
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

    final intForm = Port(
      fields: [
        StringPortField(name: 'int').required().isInt(),
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

    final doubleForm = Port(
      fields: [
        StringPortField(name: 'double').required().isDouble(),
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

    final currencyForm = Port(
      fields: [
        StringPortField(name: 'currency').required().isCurrency(),
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

    final passwordForm = Port(
      fields: [
        StringPortField(name: 'password').required().isPassword(),
        StringPortField(name: 'confirmPassword').required().isConfirmPassword(),
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

  test('options', () async {
    const male = 'm';
    const female = 'f';
    const invalidGender = 'g';
    const options = [male, female];

    final genderForm = Port(fields: [
      OptionsPortField(name: 'gender', options: options, initialValue: male).required(),
    ]);

    genderForm['gender'] = null;
    await expectInvalidForm(genderForm);

    genderForm['gender'] = male;
    await expectValidForm(genderForm);

    genderForm['gender'] = female;
    await expectValidForm(genderForm);

    genderForm['gender'] = invalidGender;
    await expectInvalidForm(genderForm);
  });

  test('embedded forms', () async {});

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

  test('conditional validation of Port.', () async {
    const empty = '';
    const name = 'John Doe';

    final disablingForm = Port(fields: [
      BoolPortField(
        name: 'enabled',
        initialValue: true,
      ),
      StringPortField(name: 'name').required(),
    ]).validateIf((port) => port['enabled']);

    disablingForm['enabled'] = true;
    disablingForm['name'] = empty;
    await expectInvalidForm(disablingForm);

    disablingForm['enabled'] = true;
    disablingForm['name'] = name;
    await expectValidForm(disablingForm);

    disablingForm['enabled'] = false;
    disablingForm['name'] = empty;
    await expectValidForm(disablingForm);

    disablingForm['enabled'] = false;
    disablingForm['name'] = name;
    await expectValidForm(disablingForm);
  });

  test('conditional validation of field.', () async {
    const empty = '';
    const name = 'John Doe';

    final form = Port(fields: [
      BoolPortField(
        name: 'enabled',
        initialValue: true,
      ),
      StringPortField(name: 'name').required().validateIf((value, port) => port['enabled']),
    ]);

    form['enabled'] = true;
    form['name'] = empty;
    await expectInvalidForm(form);

    form['enabled'] = true;
    form['name'] = name;
    await expectValidForm(form);

    form['enabled'] = false;
    form['name'] = empty;
    await expectValidForm(form);

    form['enabled'] = false;
    form['name'] = name;
    await expectValidForm(form);
  });
}

Port _getSignupForm() {
  return Port(
    fields: [
      StringPortField(name: 'name').required().minLength(4),
      StringPortField(name: 'email').required().isEmail(),
      StringPortField(name: 'password').required().isPassword(),
      StringPortField(name: 'confirmPassword').required().isConfirmPassword(),
    ],
  );
}

Future expectValidForm(Port port) async {
  final result = await port.submit();
  expect(result.isValid, isTrue);
}

Future expectInvalidForm(Port port) async {
  final result = await port.submit();
  expect(result.isValid, isFalse);
}

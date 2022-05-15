import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('initial values.', () {
    final formModel = _getSignupForm();
    expect(formModel['name'], isNull);
    expect(formModel['email'], isNull);
    expect(formModel['password'], isNull);
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
    expect(result['name'], name);
    expect(result['email'], email);
    expect(result['password'], password);
    expect(result['confirmPassword'], password);
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

  test('embedded Ports', () async {
    const empty = '';
    const name = 'John Doe';
    const food = 'Pizza';

    final registrationForm = Port(fields: [
      EmbeddedPortField(
        name: 'user',
        port: Port(fields: [
          StringPortField(name: 'name').required(),
        ]),
      ),
      EmbeddedPortField(
        name: 'order',
        port: Port(fields: [
          StringPortField(name: 'food').required(),
        ]),
      ),
    ]);

    registrationForm['user']['name'] = empty;
    registrationForm['order']['food'] = empty;
    await expectInvalidForm(registrationForm);

    registrationForm['user']['name'] = name;
    registrationForm['order']['food'] = empty;
    await expectInvalidForm(registrationForm);

    registrationForm['user']['name'] = empty;
    registrationForm['order']['food'] = food;
    await expectInvalidForm(registrationForm);

    registrationForm['user']['name'] = name;
    registrationForm['order']['food'] = food;
    await expectValidForm(registrationForm);

    final result = await registrationForm.submit();
    expect(result['user'], {'name': name});
    expect(result['order'], {'food': food});
  });

  test('spotlight', () async {
    const empty = '';
    const personalOption = 'personal';
    const businessOption = 'business';
    const personalName = 'John Doe';
    const businessName = 'JLogical';

    final formWithSpotlight = Port(fields: [
      PortSpotlight(
        optionFieldName: 'type',
        canBeNone: false,
        candidates: [
          EmbeddedPortField(
            name: personalOption,
            port: Port(
              fields: [
                StringPortField(name: 'name').required(),
              ],
            ),
          ),
          EmbeddedPortField(
            name: businessOption,
            port: Port(
              fields: [
                StringPortField(name: 'businessName').required(),
              ],
            ),
          ),
        ],
      ),
    ]);

    formWithSpotlight['type'] = null;
    formWithSpotlight[personalOption]['name'] = empty;
    formWithSpotlight[businessOption]['businessName'] = empty;
    await expectInvalidForm(formWithSpotlight);

    formWithSpotlight['type'] = null;
    formWithSpotlight[personalOption]['name'] = personalName;
    formWithSpotlight[businessOption]['businessName'] = businessName;
    await expectInvalidForm(formWithSpotlight);

    formWithSpotlight['type'] = personalOption;
    formWithSpotlight[personalOption]['name'] = empty;
    formWithSpotlight[businessOption]['businessName'] = empty;
    await expectInvalidForm(formWithSpotlight);

    formWithSpotlight['type'] = personalOption;
    formWithSpotlight[personalOption]['name'] = personalName;
    formWithSpotlight[businessOption]['businessName'] = empty;
    await expectValidForm(formWithSpotlight);

    formWithSpotlight['type'] = personalOption;
    formWithSpotlight[personalOption]['name'] = empty;
    formWithSpotlight[businessOption]['businessName'] = businessName;
    await expectInvalidForm(formWithSpotlight);

    formWithSpotlight['type'] = businessOption;
    formWithSpotlight[personalOption]['name'] = empty;
    formWithSpotlight[businessOption]['businessName'] = businessName;
    await expectValidForm(formWithSpotlight);
  });

  test('reactivity', () async {
    const name = 'John Doe';

    final formModel = _getSignupForm();

    final completer = Completer();
    formModel.getFieldValueXByName('name').listen((value) {
      if (!completer.isCompleted && value == name) {
        completer.complete(value);
      }
    });

    formModel['name'] = name;

    final value = await completer.future;

    expect(value, name);
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

  test('custom form validation', () async {
    const empty = '';
    const registeredEmail = 'a@b.com';
    const unregisteredEmail = 'test@test.com';

    const registeredEmails = [registeredEmail];
    final loginForm = _getLoginForm(registeredEmails);

    loginForm['email'] = empty;
    await expectInvalidForm(loginForm);

    loginForm['email'] = registeredEmail;
    await expectValidForm(loginForm);

    loginForm['email'] = unregisteredEmail;
    await expectInvalidForm(loginForm);
  });

  test('field errors', () async {
    const empty = '';
    const invalidEmail = 'asj@';
    const shortPassword = 'pass';
    const invalidPassword = r'pa$$w0rd';

    final form = _getSignupForm();
    form['name'] = empty;
    form['email'] = invalidEmail;
    form['password'] = shortPassword;
    form['confirmPassword'] = invalidPassword;

    final result = await form.submit();

    expect(result.exception['name'], isA<RequiredValidationException>());
    expect(result.exception['email'], isA<IsEmailValidationException>());
    expect(result.exception['password'], isA<MinLengthValidationException>());
    expect(result.exception['confirmPassword'], isA<IsConfirmPasswordValidationException>());
  });

  test('field errors in additional validator', () async {
    const registeredEmail = 'a@b.com';
    const unregisteredEmail = 'test@test.com';

    const registeredEmails = [registeredEmail];
    final loginForm = _getLoginForm(registeredEmails);

    loginForm['email'] = unregisteredEmail;

    final result = await loginForm.submit();

    expect(result.isValid, isFalse);
    expect(result.exception['email'], isA<_UnregisteredEmailValidationException>());
  });

  test('reactive errors', () async {
    const empty = '';

    final formModel = _getSignupForm();

    final completer = Completer();
    formModel.getExceptionXByName('name').listen((exception) {
      if (!completer.isCompleted && exception != null) {
        completer.complete(exception);
      }
    });

    formModel['name'] = empty;

    await formModel.submit();

    final exception = await completer.future;

    expect(exception, isA<RequiredValidationException>());
  });
}

Port _getLoginForm(List<String> registeredEmails) {
  return Port(fields: [
    StringPortField(name: 'email').required().isEmail(),
  ]).withValidator(Validator.of((port) {
    String email = port['email'];
    if (!registeredEmails.contains(email)) {
      throw _UnregisteredEmailValidationException(failedValue: email).forField('email');
    }
  }));
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

class _UnregisteredEmailValidationException extends ValidationException<String> {
  _UnregisteredEmailValidationException({required super.failedValue});
}

Future expectValidForm(Port port) async {
  final result = await port.submit();
  expect(result.isValid, isTrue);
}

Future expectInvalidForm(Port port) async {
  final result = await port.submit();
  expect(result.isValid, isFalse);
}

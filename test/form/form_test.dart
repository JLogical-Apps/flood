import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('initial values.', () {
    final formModel = _initFormModel();
    expect(formModel['name'], '');
    expect(formModel['email'], '');
    expect(formModel['password'], '');
  });

  test('changing values.', () {
    const name = 'Jake';
    const email = 'a@b.com';
    const password = 'asdfasdf';

    final formModel = _initFormModel();

    formModel['name'] = name;
    formModel['email'] = email;
    formModel['password'] = password;

    expect(formModel['name'], name);
    expect(formModel['email'], email);
    expect(formModel['password'], password);
  });

  test('validation', () async {
    const name = 'Jake';
    const email = 'a@b.com';
    const password = 'asdfasdf';

    final formModel = _initFormModel();

    formModel['name'] = name;
    formModel['email'] = email;
    formModel['password'] = password;

    final result = await formModel.submit();

    expect(result.isValid, isTrue);
    expect(result.data['name'], name);
    expect(result.data['email'], email);
    expect(result.data['password'], password);
  });

  test('invalid validation', () async {
    const name = 'Jake';
    const email = 'a@b.com';
    const invalidPassword = 'as';

    final formModel = _initFormModel();

    formModel['name'] = name;
    formModel['email'] = email;
    formModel['password'] = invalidPassword;

    final result = await formModel.submit();

    expect(result.isValid, isFalse);
  });

  test('reactivity', () async {
    const name = 'Jake';

    final formModel = _initFormModel();

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

FormModel _initFormModel() {
  return FormModel(
    fields: [
      StringFormField(
        name: 'name',
        validators: [
          Validator.required().forForm(),
          Validator.minLength(4).forForm(),
        ],
      ),
      StringFormField(
        name: 'email',
        validators: [
          Validator.required().forForm(),
          Validator.isEmail().forForm(),
        ],
      ),
      StringFormField(
        name: 'password',
        validators: [
          Validator.required().forForm(),
          Validator.isPassword().forForm(),
        ],
      ),
    ],
  );
}

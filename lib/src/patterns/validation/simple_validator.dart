import 'dart:async';

import 'validator.dart';

class SimpleValidator<V> implements Validator<V> {
  final FutureOr Function(V value) validator;

  SimpleValidator({required this.validator});

  @override
  FutureOr onValidate(V value) {
    return validator(value);
  }
}

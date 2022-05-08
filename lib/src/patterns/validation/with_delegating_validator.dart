import 'dart:async';

import 'validator.dart';

mixin WithDelegatingValidator<V> implements Validator<V> {
  Validator<V> get validator;

  FutureOr<V> onValidate(V value) async {
    return await validator.onValidate(value);
  }
}

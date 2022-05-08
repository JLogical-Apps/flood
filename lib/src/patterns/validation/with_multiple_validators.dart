import 'dart:async';

import 'validator.dart';

mixin WithMultipleValidators<V> implements Validator<V> {
  List<Validator<V>> get validators;

  @override
  FutureOr<V> onValidate(V value) async {
    return await Validator.multiple(validators).validate(value);
  }
}

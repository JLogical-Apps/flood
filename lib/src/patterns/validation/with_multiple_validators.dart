import 'dart:async';

import 'validator.dart';

mixin WithMultipleValidators<V> implements Validator<V> {
  List<Validator<V>> get validators;

  @override
  Future<void> onValidate(V value) async {
    await Validator.multiple(validators).validate(value);
  }
}

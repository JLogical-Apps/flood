import 'dart:async';

import '../validator.dart';

class ComposedValidator<C> extends Validator<C> {
  final List<Validator<C>> validators;

  ComposedValidator({required this.validators});

  @override
  FutureOr onValidate(C context) async {
    for (final validator in validators) {
      await validator.onValidate(context);
    }
  }

  @override
  ComposedValidator<C> then(Validator<C> otherValidator) {
    validators.add(otherValidator);
    return this;
  }
}

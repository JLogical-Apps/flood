import 'dart:async';

import '../validator.dart';

abstract class ComposedValidator<C> extends Validator<C> {
  List<Validator<C>> get validators;

  @override
  Future onValidate(C context) async {
    for (final validator in validators) {
      await validator.onValidate(context);
    }
  }
}

class SimpleComposedValidator<C> extends ComposedValidator<C> {
  @override
  final List<Validator<C>> validators;

  SimpleComposedValidator({required this.validators});
}

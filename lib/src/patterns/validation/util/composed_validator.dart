import 'dart:async';

import '../sync_validator.dart';
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

abstract class SyncComposedValidator<C> extends SyncValidator<C> {
  List<SyncValidator<C>> get validators;

  @override
  void onValidateSync(C context) {
    for (final validator in validators) {
      validator.onValidate(context);
    }
  }
}

class SimpleComposedValidator<C> extends ComposedValidator<C> {
  @override
  final List<Validator<C>> validators;

  SimpleComposedValidator({required this.validators});
}

class SimpleSyncComposedValidator<C> extends SyncComposedValidator<C> {
  @override
  final List<SyncValidator<C>> validators;

  SimpleSyncComposedValidator({required this.validators});
}

import 'dart:async';

import 'validation_exception.dart';
import 'validator.dart';
import 'validators/util/mapped_validator.dart';

abstract class SyncValidator<V> implements Validator<V> {
  void onValidateSync(V value);

  @override
  FutureOr onValidate(V value) {
    onValidateSync(value);
  }
}

extension DefaultSyncValidatorExtensions<V> on SyncValidator<V> {
  void validateSync(V value) {
    onValidateSync(value);
  }

  bool isValidSync(V value) {
    return (getExceptionSync(value)) == null;
  }

  Object? getExceptionSync(V value) {
    try {
      validateSync(value);
      return null;
    } on ValidationException catch (e) {
      return e;
    }
  }

  SyncMappedValidator<U, V> syncMap<U>(V mapper(U value)) {
    return SyncMappedValidator(parent: this, valueMapper: mapper);
  }
}

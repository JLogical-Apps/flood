import 'dart:async';

import 'package:jlogical_utils/src/patterns/validation/util/composed_validator.dart';
import 'validation_exception.dart';

/// Validates data [V] with the [onValidate].
abstract class Validator<V> {
  /// Validates [value].
  /// If valid, no exception is thrown.
  /// If invalid, a [ValidationException] is thrown.
  FutureOr onValidate(V value);

  Future validate(V value) async {
    await onValidate(value);
  }

  Future<bool> isValid(V value) async {
    return (await getException(value)) == null;
  }

  Future getException(V value) async {
    try {
      await validate(value);
      return null;
    } on ValidationException catch (e) {
      return e;
    }
  }

  ComposedValidator<V> then(Validator<V> otherValidator) {
    return ComposedValidator(validators: [this, otherValidator]);
  }
}

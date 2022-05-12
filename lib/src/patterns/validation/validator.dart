import 'dart:async';

import 'package:jlogical_utils/src/patterns/validation/simple_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/util/composed_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/datetime/is_after_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/datetime/is_before_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/length/max_length_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/length/min_length_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/required/required_validator.dart';

import 'validation_exception.dart';
import 'validators/email/is_email_validator.dart';
import 'validators/list/is_one_of_validator.dart';
import 'validators/parsing/is_currency_validator.dart';
import 'validators/parsing/is_double_validator.dart';
import 'validators/parsing/is_int_validator.dart';
import 'validators/password/is_password_validator.dart';
import 'validators/util/mapped_validator.dart';

/// Validates data [V] with the [onValidate].
abstract class Validator<V> {
  /// Validates [value].
  /// If valid, no exception is thrown.
  /// If invalid, a [ValidationException] is thrown.
  FutureOr onValidate(V value);

  static SimpleValidator<V> of<V>(FutureOr validator(V value)) {
    return SimpleValidator(validator: validator);
  }

  static RequiredValidator<V> required<V>() {
    return RequiredValidator<V>();
  }

  static MinLengthValidator<V> minLength<V>(int minLength) {
    return MinLengthValidator<V>(minLength: minLength);
  }

  static MaxLengthValidator<V> maxLength<V>(int maxLength) {
    return MaxLengthValidator<V>(maxLength: maxLength);
  }

  static IsIntValidator isInt() {
    return IsIntValidator();
  }

  static IsDoubleValidator isDouble() {
    return IsDoubleValidator();
  }

  static IsCurrencyValidator isCurrency() {
    return IsCurrencyValidator();
  }

  static IsEmailValidator isEmail() {
    return IsEmailValidator();
  }

  static IsPasswordValidator isPassword({int minLength: 6}) {
    return IsPasswordValidator(minLength: minLength);
  }

  static ComposedValidator<C> multiple<C>(List<Validator<C>> validators) {
    return SimpleComposedValidator(validators: validators);
  }

  static IsAfterValidator isAfter(DateTime after) {
    return IsAfterValidator(after: after);
  }

  static IsBeforeValidator isBefore(DateTime before) {
    return IsBeforeValidator(before: before);
  }

  static IsOneOfValidator<T> isOneOf<T>(List<T> options) {
    return IsOneOfValidator(options: options);
  }
}

extension DefaultValidatorExtensions<V> on Validator<V> {
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

  MappedValidator<U, V> map<U>(V mapper(U value)) {
    return MappedValidator(parent: this, valueMapper: mapper);
  }
}

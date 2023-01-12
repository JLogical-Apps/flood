import 'dart:async';

import 'package:utils_core/utils_core.dart';

typedef SimplePortValue<T> = PortValue<T, T>;

abstract class PortValue<T, S> implements ValidatorWrapper<T, String> {
  T get value;

  dynamic get error;

  FutureOr<S> submit(T value);

  factory PortValue({
    required T value,
    dynamic error,
    Validator<T, String>? validator,
    FutureOr<S> Function(T value)? submitMapper,
  }) =>
      _PortValueImpl(
        value: value,
        error: error,
        validator: validator ?? Validator.empty(),
        submitMapper: submitMapper,
      );

  static SimplePortValue<String> string({String? initialValue}) {
    return PortValue(value: initialValue ?? '', validator: Validator.empty());
  }
}

extension PortValueExtensions<T, S> on PortValue<T, S> {
  T? getOrNull() => error == null ? value : null;

  PortValue<T, S> copyWith({
    T? value,
    required dynamic error,
    Validator<T, String>? validator,
  }) =>
      PortValue(
        value: value ?? this.value,
        error: error,
        validator: validator ?? this.validator,
        submitMapper: submit,
      );

  PortValue<T, S> copyWithValue(T value) => copyWith(value: value, error: error);

  PortValue<T, S> copyWithError(dynamic error) => copyWith(error: error);

  PortValue<T, S> copyWithValidator(Validator<T, String> validator) => copyWith(
        error: error,
        validator: this.validator + validator,
      );

  PortValue<T, S> isNotNull() => copyWithValidator(this + Validator.isNotNull());
}

mixin IsPortValue<T, S> implements PortValue<T, S> {}

class _PortValueImpl<T, S> with IsPortValue<T, S>, IsValidatorWrapper<T, String> {
  @override
  final T value;

  @override
  final dynamic error;

  @override
  final Validator<T, String> validator;

  final FutureOr<S> Function(T value)? submitMapper;

  _PortValueImpl({
    required this.value,
    this.error,
    required this.validator,
    required this.submitMapper,
  });

  @override
  Future<S> submit(T value) async {
    if (submitMapper == null) {
      return value as S;
    }

    return await submitMapper!(value);
  }
}

extension StringPortValueExtensions<S> on PortValue<String, S> {
  PortValue<String, S> isNotBlank() => copyWithValidator(Validator.isNotBlank().asNonNullable());

  PortValue<String, S> isEmail() => copyWithValidator(Validator.isEmail().asNonNullable());
}

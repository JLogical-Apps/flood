import 'dart:async';

import 'package:port_core/src/port.dart';
import 'package:utils_core/utils_core.dart';

typedef SimplePortValue<T> = PortValue<T, T>;

abstract class PortValue<T, S> with IsValidatorWrapper<T, String> {
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

  static SimplePortValue<T> option<T>({required List<T> options, required T initialValue}) {
    return PortValue(
      value: initialValue,
      validator: Validator((item) => options.contains(item) ? null : '[$item] is not a valid choice!'),
    );
  }

  static PortValue<Port<T>, T> port<T>({required Port<T> port}) {
    return PortValue(
      value: port,
      validator: Validator((port) async {
        final result = await port.submit();
        if (!result.isValid) {
          return 'Embedded port [$port] is not valid!';
        }
        return null;
      }),
      submitMapper: (port) async => (await port.submit()).data,
    );
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

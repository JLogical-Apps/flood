import 'dart:async';

import 'package:port_core/src/port.dart';
import 'package:utils_core/utils_core.dart';

typedef SimplePortField<T> = PortField<T, T>;

abstract class PortField<T, S> with IsValidatorWrapper<T, String> {
  T get value;

  dynamic get error;

  FutureOr<S> submit(T value);

  factory PortField({
    required T value,
    dynamic error,
    Validator<T, String>? validator,
    FutureOr<S> Function(T value)? submitMapper,
  }) =>
      _PortFieldImpl(
        value: value,
        error: error,
        validator: validator ?? Validator.empty(),
        submitMapper: submitMapper,
      );

  static SimplePortField<String> string({String? initialValue}) {
    return PortField(value: initialValue ?? '', validator: Validator.empty());
  }

  static SimplePortField<T> option<T>({required List<T> options, required T initialValue}) {
    return PortField(
      value: initialValue,
      validator: Validator((item) => options.contains(item) ? null : '[$item] is not a valid choice!'),
    );
  }

  static PortField<Port<T>, T> port<T>({required Port<T> port}) {
    return PortField(
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

extension PortFieldExtensions<T, S> on PortField<T, S> {
  T? getOrNull() => error == null ? value : null;

  PortField<T, S> copyWith({
    T? value,
    required dynamic error,
    Validator<T, String>? validator,
  }) =>
      PortField(
        value: value ?? this.value,
        error: error,
        validator: validator ?? this.validator,
        submitMapper: submit,
      );

  PortField<T, S> copyWithValue(T value) => copyWith(value: value, error: error);

  PortField<T, S> copyWithError(dynamic error) => copyWith(error: error);

  PortField<T, S> copyWithValidator(Validator<T, String> validator) => copyWith(
        error: error,
        validator: this.validator + validator,
      );

  PortField<T, S> isNotNull() => copyWithValidator(this + Validator.isNotNull());
}

mixin IsPortField<T, S> implements PortField<T, S> {}

class _PortFieldImpl<T, S> with IsPortField<T, S>, IsValidatorWrapper<T, String> {
  @override
  final T value;

  @override
  final dynamic error;

  @override
  final Validator<T, String> validator;

  final FutureOr<S> Function(T value)? submitMapper;

  _PortFieldImpl({
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

extension StringPortFieldExtensions<S> on PortField<String, S> {
  PortField<String, S> isNotBlank() => copyWithValidator(Validator.isNotBlank().asNonNullable());

  PortField<String, S> isEmail() => copyWithValidator(Validator.isEmail().asNonNullable());
}

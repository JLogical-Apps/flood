import 'dart:async';

import 'package:port_core/port_core.dart';
import 'package:port_core/src/validator_port_field.dart';
import 'package:utils_core/utils_core.dart';

typedef SimplePortField<T> = PortField<T, T>;

abstract class PortField<T, S> with IsValidatorWrapper<T, String> {
  T get value;

  dynamic get error;

  FutureOr<S> submit(T value);

  PortField<T, S> copyWith({required T value, required dynamic error});

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
    return OptionsPortField(portField: PortField(value: initialValue), options: options);
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

  PortField<T, S> copyWithValue(T value) => copyWith(value: value, error: error);

  PortField<T, S> copyWithError(dynamic error) => copyWith(value: value, error: error);

  PortField<T, S> withValidator(Validator<T, String> validator) => ValidatorPortField(
        portField: this,
        additionalValidator: validator,
      );

  PortField<T, S> isNotNull() => withValidator(this + Validator.isNotNull());
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

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return _PortFieldImpl(
      value: value,
      error: error,
      validator: validator,
      submitMapper: submitMapper,
    );
  }
}

extension StringPortFieldExtensions<S> on PortField<String, S> {
  PortField<String, S> isNotBlank() => withValidator(Validator.isNotBlank().asNonNullable());

  PortField<String, S> isEmail() => withValidator(Validator.isEmail().asNonNullable());
}

abstract class PortFieldWrapper<T, S> implements PortField<T, S> {
  PortField<T, S> get portField;
}

mixin IsPortFieldWrapper<T, S> implements PortFieldWrapper<T, S> {
  @override
  T get value => portField.value;

  @override
  dynamic get error => portField.error;

  @override
  FutureOr<S> submit(T value) => portField.submit(value);

  @override
  Validator<T, String> get validator => portField.validator;

  @override
  Future<String?> onValidate(data) {
    return validator.validate(data);
  }
}

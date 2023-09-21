import 'dart:async';

import 'package:port_core/src/port.dart';
import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_field_validator_context.dart';

class FallbackPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final T Function(Port port) fallbackGetter;

  FallbackPortField({required this.portField, required this.fallbackGetter});

  T getFallback() {
    return fallbackGetter(port);
  }

  @override
  S submitRaw(T value) {
    return (isEmpty(value) ? fallbackGetter(port) : value) as S;
  }

  @override
  FutureOr<S> submit(T value) {
    return (isEmpty(value) ? fallbackGetter(port) : value) as S;
  }

  @override
  Future<String?> onValidate(PortFieldValidatorContext data) {
    final valueToValidate = (isEmpty(value) ? fallbackGetter(data.port) : value);
    return portField.onValidate(data.withValue(valueToValidate));
  }

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return FallbackPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      fallbackGetter: fallbackGetter,
    );
  }

  static bool isEmpty(dynamic value) => value == null || value == '';
}

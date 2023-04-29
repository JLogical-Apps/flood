import 'dart:async';

import 'package:port_core/src/port_field.dart';

class FallbackPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final T Function() fallbackGetter;

  FallbackPortField({required this.portField, required this.fallbackGetter});

  T getFallback() {
    return fallbackGetter();
  }

  @override
  S submitRaw(T value) {
    return (isEmpty(value) ? fallbackGetter() : value) as S;
  }

  @override
  FutureOr<S> submit(T value) {
    return (isEmpty(value) ? fallbackGetter() : value) as S;
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

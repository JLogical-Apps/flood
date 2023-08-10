import 'dart:async';

import 'package:port_core/port_core.dart';
import 'package:port_core/src/port_field_validator_context.dart';
import 'package:utils_core/utils_core.dart';

class MapPortField<T1, S1, T2, S2> with IsPortField<T2, S2> {
  final PortField<T1, S1> portField;

  final T1 Function(T2 value) newToSourceMapper;
  final T2 Function(T1 value) sourceToNewMapper;
  final S2 Function(S1 value) submitMapper;

  MapPortField({
    required this.portField,
    required this.newToSourceMapper,
    required this.sourceToNewMapper,
    required this.submitMapper,
  });

  @override
  PortField<T2, S2> copyWith({required T2 value, required error}) {
    return MapPortField<T1, S1, T2, S2>(
      portField: portField.copyWith(value: newToSourceMapper(value), error: error),
      newToSourceMapper: newToSourceMapper,
      sourceToNewMapper: sourceToNewMapper,
      submitMapper: submitMapper,
    );
  }

  @override
  get error => portField.error;

  @override
  Future<String?> onValidate(PortFieldValidatorContext<T2> data) async {
    return validator.onValidate(data);
  }

  @override
  FutureOr<S2> submit(Port port, T2 value) async {
    final sourceValue = newToSourceMapper(value);
    final sourceSubmit = await portField.submit(port, sourceValue);
    return submitMapper(sourceSubmit);
  }

  @override
  S2 submitRaw(Port port, T2 value) {
    final sourceValue = newToSourceMapper(value);
    final sourceSubmit = portField.submitRaw(port, sourceValue);
    return submitMapper(sourceSubmit);
  }

  @override
  Validator<PortFieldValidatorContext<T2>, String> get validator =>
      portField.validator.map<PortFieldValidatorContext<T2>>((context) => context.map<T1>((value) => newToSourceMapper(value)));

  @override
  T2 get value => sourceToNewMapper(portField.value);

  @override
  PortFieldValidatorContext<T2> createValidationContext(Port port) {
    return portField.createValidationContext(port).map(sourceToNewMapper);
  }
}

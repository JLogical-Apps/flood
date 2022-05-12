import 'dart:async';

import '../../../patterns/export_core.dart';
import '../port.dart';
import 'port_field_validation_context.dart';
import 'simple_port_field_validator.dart';

abstract class PortFieldValidator<V> extends Validator<PortFieldValidationContext> {
  static SimplePortFieldValidator<V> of<V>(FutureOr validator(V value, Port port)) {
    return SimplePortFieldValidator(validator: validator);
  }
}

extension PortFieldValidatorExtensions<V> on Validator<V> {
  PortFieldValidator<V> forPort() {
    return SimplePortFieldValidator(validator: (value, port) => validate(value));
  }
}

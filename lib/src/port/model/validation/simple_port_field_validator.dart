import 'dart:async';

import '../port.dart';
import 'port_field_validation_context.dart';
import 'port_field_validator.dart';

class SimplePortFieldValidator<V> extends PortFieldValidator<V> {
  final FutureOr Function(V value, Port port) validator;

  SimplePortFieldValidator({required this.validator});

  @override
  FutureOr onValidate(PortFieldValidationContext context) {
    return validator(context.value, context.port);
  }
}

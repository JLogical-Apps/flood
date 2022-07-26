import 'dart:async';

import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/model/validation/port_field_validation_context.dart';

import '../../../patterns/validation/validators/required/required_validator.dart';
import 'port_field_validator.dart';

class RequiredPortFieldValidator<V> extends PortFieldValidator<V> {
  @override
  FutureOr onValidate(PortFieldValidationContext value) {
    return RequiredValidator().validate(value);
  }
}

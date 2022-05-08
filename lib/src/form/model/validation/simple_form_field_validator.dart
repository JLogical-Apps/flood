import 'dart:async';

import 'package:jlogical_utils/src/form/model/validation/form_field_validation_context.dart';

import '../form_model.dart';
import 'form_field_validator.dart';

class SimpleFormFieldValidator<V> extends FormFieldValidator<V> {
  final FutureOr Function(V value, FormModel form) validator;

  SimpleFormFieldValidator({required this.validator});

  @override
  FutureOr onValidate(FormFieldValidationContext<V> context) {
    return validator(context.value, context.form);
  }
}

import 'dart:async';

import 'package:jlogical_utils/src/form/model/validation/simple_form_field_validator.dart';

import '../../../patterns/export_core.dart';
import '../form_model.dart';
import 'form_field_validation_context.dart';

abstract class FormFieldValidator<V> extends Validator<FormFieldValidationContext> {
  static SimpleFormFieldValidator<V> of<V>(FutureOr validator(V value, FormModel form)) {
    return SimpleFormFieldValidator(validator: validator);
  }
}

extension FormFieldValidatorExtensions on Validator {
  FormFieldValidator<V> forForm<V>() {
    return SimpleFormFieldValidator(validator: (value, form) => validate(value));
  }
}

import 'dart:async';

import 'package:jlogical_utils/src/form/model/validation/form_field_validation_context.dart';
import 'package:jlogical_utils/src/form/model/validation/is_confirm_password_validation_exception.dart';

import 'form_field_validator.dart';

class IsConfirmPasswordValidator extends FormFieldValidator<String> {
  final String passwordFieldName;

  IsConfirmPasswordValidator({this.passwordFieldName: 'password'});

  @override
  void onValidate(FormFieldValidationContext context) {
    if (context.form[passwordFieldName] != context.value) {
      throw IsConfirmPasswordValidationException(validator: this, failedValue: context);
    }
  }
}

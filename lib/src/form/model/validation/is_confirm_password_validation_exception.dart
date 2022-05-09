import 'package:jlogical_utils/src/form/model/validation/form_field_validation_context.dart';

import 'is_confirm_password_validator.dart';

import '../../../patterns/export_core.dart';

class IsConfirmPasswordValidationException
    extends ValidationException<IsConfirmPasswordValidator, FormFieldValidationContext> {
  IsConfirmPasswordValidationException({
    required IsConfirmPasswordValidator validator,
    required FormFieldValidationContext failedValue,
  }) : super(validator: validator, failedValue: failedValue);
}

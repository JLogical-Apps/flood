import '../../../patterns/export_core.dart';
import 'is_confirm_password_validator.dart';
import 'port_field_validation_context.dart';

class IsConfirmPasswordValidationException
    extends ValidationException<IsConfirmPasswordValidator, PortFieldValidationContext> {
  IsConfirmPasswordValidationException({
    required IsConfirmPasswordValidator validator,
    required PortFieldValidationContext failedValue,
  }) : super(validator: validator, failedValue: failedValue);
}

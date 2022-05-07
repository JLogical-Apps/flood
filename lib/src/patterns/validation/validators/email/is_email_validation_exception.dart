import '../../validation_exception.dart';
import 'is_email_validator.dart';

class IsEmailValidationException extends ValidationException<IsEmailValidator, String?> {
  IsEmailValidationException({required IsEmailValidator validator, required String? failedValue})
      : super(validator: validator, failedValue: failedValue);
}

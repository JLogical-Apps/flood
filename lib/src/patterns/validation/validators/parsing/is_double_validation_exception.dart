import '../../validation_exception.dart';
import 'is_double_validator.dart';

class IsDoubleValidationException extends ValidationException<IsDoubleValidator, String?> {
  IsDoubleValidationException({required IsDoubleValidator validator, required String? failedValue})
      : super(validator: validator, failedValue: failedValue);
}

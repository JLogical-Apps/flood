import '../../validation_exception.dart';
import 'is_after_validator.dart';

class IsAfterValidationException extends ValidationException<IsAfterValidator, DateTime?> {
  IsAfterValidationException({required IsAfterValidator validator, required DateTime? failedValue})
      : super(validator: validator, failedValue: failedValue);
}

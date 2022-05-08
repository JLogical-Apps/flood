import '../../validation_exception.dart';
import 'is_before_validator.dart';

class IsBeforeValidationException extends ValidationException<IsBeforeValidator, DateTime?> {
  IsBeforeValidationException({required IsBeforeValidator validator, required DateTime? failedValue})
      : super(validator: validator, failedValue: failedValue);
}

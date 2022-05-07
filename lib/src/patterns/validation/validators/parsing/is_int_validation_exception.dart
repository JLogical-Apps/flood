import '../../validation_exception.dart';
import 'is_int_validator.dart';

class IsIntValidationException extends ValidationException<IsIntValidator, String?> {
  IsIntValidationException({required IsIntValidator validator, required String? failedValue})
      : super(validator: validator, failedValue: failedValue);
}

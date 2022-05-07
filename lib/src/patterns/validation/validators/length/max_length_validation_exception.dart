import '../../validation_exception.dart';
import 'max_length_validator.dart';

class MaxLengthValidationException extends ValidationException<MaxLengthValidator, dynamic> {
  MaxLengthValidationException({required MaxLengthValidator validator, required failedValue})
      : super(validator: validator, failedValue: failedValue);

  int get length => failedValue?.toString().length ?? 0;

  int get maxLength => validator.maxLength;
}

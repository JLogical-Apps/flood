import '../../validation_exception.dart';
import 'min_length_validator.dart';

class MinLengthValidationException extends ValidationException<MinLengthValidator, dynamic> {
  MinLengthValidationException({required MinLengthValidator validator, required failedValue})
      : super(validator: validator, failedValue: failedValue);

  int get length => failedValue?.toString().length ?? 0;

  int get minLength => validator.minLength;
}

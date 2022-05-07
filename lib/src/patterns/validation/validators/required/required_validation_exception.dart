import '../../validation_exception.dart';
import 'required_validator.dart';

class RequiredValidationException<V> extends ValidationException<RequiredValidator<V>, V> {
  RequiredValidationException({required RequiredValidator<V> validator, required failedValue})
      : super(validator: validator, failedValue: failedValue);
}

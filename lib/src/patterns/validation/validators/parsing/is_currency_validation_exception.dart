import '../../validation_exception.dart';
import 'is_currency_validator.dart';

class IsCurrencyValidationException extends ValidationException<IsCurrencyValidator, String?> {
  IsCurrencyValidationException({required IsCurrencyValidator validator, required String? failedValue})
      : super(validator: validator, failedValue: failedValue);
}

import '../../validation_exception.dart';

class IsCurrencyValidationException extends ValidationException<String?> {
  IsCurrencyValidationException({required super.failedValue});
}

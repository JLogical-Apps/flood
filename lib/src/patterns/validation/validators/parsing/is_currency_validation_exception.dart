import '../../validation_exception.dart';

class IsCurrencyValidationException extends ValidationException<String?> {
  IsCurrencyValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be a currency!';
  }
}

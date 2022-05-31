import '../../validation_exception.dart';

class IsAfterNowValidationException extends ValidationException<DateTime> {
  IsAfterNowValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be after today!';
  }
}

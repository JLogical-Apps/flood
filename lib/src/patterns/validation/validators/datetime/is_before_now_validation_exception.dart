import '../../validation_exception.dart';

class IsBeforeNowValidationException extends ValidationException<DateTime> {
  IsBeforeNowValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be before today!';
  }
}

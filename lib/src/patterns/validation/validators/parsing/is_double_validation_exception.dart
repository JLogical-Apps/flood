import '../../validation_exception.dart';

class IsDoubleValidationException extends ValidationException<String?> {
  IsDoubleValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be a number!';
  }
}

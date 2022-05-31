import '../../validation_exception.dart';

class IsIntValidationException extends ValidationException<String?> {
  IsIntValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be a whole number!';
  }
}

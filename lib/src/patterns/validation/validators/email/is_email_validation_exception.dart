import '../../validation_exception.dart';

class IsEmailValidationException extends ValidationException<String?> {
  IsEmailValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be an email!';
  }
}

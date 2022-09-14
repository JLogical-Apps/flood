import '../../validation_exception.dart';

class IsPhoneValidationException extends ValidationException<String?> {
  IsPhoneValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Must be a valid phone number!';
  }
}

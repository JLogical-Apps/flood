import '../../validation_exception.dart';

class IsEmailValidationException extends ValidationException<String?> {
  IsEmailValidationException({required super.failedValue});
}

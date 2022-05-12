import '../../validation_exception.dart';

class IsIntValidationException extends ValidationException<String?> {
  IsIntValidationException({required super.failedValue});
}

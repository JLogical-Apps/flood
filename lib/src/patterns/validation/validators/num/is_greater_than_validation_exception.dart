import '../../validation_exception.dart';

class IsGreaterThanValidationException extends ValidationException<num> {
  IsGreaterThanValidationException({required super.failedValue});
}

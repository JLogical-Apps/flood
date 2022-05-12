import '../../validation_exception.dart';

class IsLessThanValidationException extends ValidationException<num> {
  IsLessThanValidationException({required super.failedValue});
}

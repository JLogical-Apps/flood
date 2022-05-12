import '../../validation_exception.dart';

class IsBeforeValidationException extends ValidationException<DateTime> {
  IsBeforeValidationException({required super.failedValue});
}

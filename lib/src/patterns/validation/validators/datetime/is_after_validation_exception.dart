import '../../validation_exception.dart';

class IsAfterValidationException extends ValidationException<DateTime> {
  IsAfterValidationException({required super.failedValue});
}

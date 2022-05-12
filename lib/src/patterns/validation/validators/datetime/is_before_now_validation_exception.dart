import '../../validation_exception.dart';

class IsBeforeNowValidationException extends ValidationException<DateTime> {
  IsBeforeNowValidationException({required super.failedValue});
}

import '../../validation_exception.dart';

class RequiredValidationException<V> extends ValidationException<V> {
  RequiredValidationException({required super.failedValue});
}

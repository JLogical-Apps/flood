import '../../validation_exception.dart';

class IsOneOfValidationException<T> extends ValidationException<T> {
  IsOneOfValidationException({required super.failedValue});

  @override
  String toString() {
    return 'Not a valid value!';
  }
}

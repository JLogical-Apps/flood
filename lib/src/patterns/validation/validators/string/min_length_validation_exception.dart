import '../../validation_exception.dart';

class MinLengthValidationException extends ValidationException<dynamic> {
  final int minLength;

  MinLengthValidationException({required super.failedValue, required this.minLength});

  int get length => failedValue?.toString().length ?? 0;
}

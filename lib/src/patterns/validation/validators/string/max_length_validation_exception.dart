import '../../validation_exception.dart';

class MaxLengthValidationException extends ValidationException<dynamic> {
  final int maxLength;

  MaxLengthValidationException({required super.failedValue, required this.maxLength});

  int get length => failedValue?.toString().length ?? 0;

  @override
  String toString() {
    return 'Cannot be longer than $maxLength characters!';
  }
}

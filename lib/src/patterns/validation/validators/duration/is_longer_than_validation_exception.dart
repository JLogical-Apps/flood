import '../../validation_exception.dart';

class IsLongerThanValidationException extends ValidationException<Duration> {
  final Duration duration;

  IsLongerThanValidationException({required this.duration, required super.failedValue});

  @override
  String toString() {
    return 'Must be longer than $duration';
  }
}

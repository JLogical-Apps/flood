import '../../validation_exception.dart';

class IsShorterThanValidationException extends ValidationException<Duration> {
  final Duration duration;

  IsShorterThanValidationException({required this.duration, required super.failedValue});

  @override
  String toString() {
    return 'Must be shorter than $duration';
  }
}

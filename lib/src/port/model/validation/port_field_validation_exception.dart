import '../../../patterns/export_core.dart';

class PortFieldValidationException extends ValidationException<String> {
  final ValidationException exception;

  PortFieldValidationException({required super.failedValue, required this.exception});
}

extension PortValidationExceptionExtensions on ValidationException {
  PortFieldValidationException forField(String fieldName) {
    return PortFieldValidationException(failedValue: fieldName, exception: this);
  }
}

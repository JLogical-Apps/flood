import '../../../patterns/export_core.dart';
import '../port_field.dart';

class PortFieldValidationException extends ValidationException<PortField> {
  final ValidationException exception;

  PortFieldValidationException({required super.failedValue, required this.exception});
}

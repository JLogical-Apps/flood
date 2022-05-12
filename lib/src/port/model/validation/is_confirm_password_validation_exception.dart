import '../../../patterns/export_core.dart';
import 'port_field_validation_context.dart';

class IsConfirmPasswordValidationException extends ValidationException<PortFieldValidationContext> {
  IsConfirmPasswordValidationException({required super.failedValue});
}

import 'is_confirm_password_validation_exception.dart';
import 'port_field_validation_context.dart';
import 'port_field_validator.dart';

class IsConfirmPasswordValidator extends PortFieldValidator<String> {
  final String passwordFieldName;

  IsConfirmPasswordValidator({this.passwordFieldName: 'password'});

  @override
  void onValidate(PortFieldValidationContext context) {
    if (context.port[passwordFieldName] != context.value) {
      throw IsConfirmPasswordValidationException(validator: this, failedValue: context);
    }
  }
}

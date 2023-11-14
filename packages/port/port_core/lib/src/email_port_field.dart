import 'package:port_core/src/port_field.dart';
import 'package:utils_core/utils_core.dart';

class EmailPortField<S> with IsPortFieldWrapper<String, S> {
  @override
  final PortField<String, S> portField;

  final bool isEmail;

  EmailPortField({required PortField<String, S> portField, this.isEmail = true})
      : portField = portField.withValidator(Validator.isEmail().asNonNullable().forPortField());

  @override
  PortField<String, S> copyWith({required String value, required error}) {
    return EmailPortField<S>(
      portField: portField.copyWith(value: value, error: error),
      isEmail: isEmail,
    );
  }
}

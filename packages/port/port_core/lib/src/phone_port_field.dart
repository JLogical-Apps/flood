import 'package:port_core/src/port_field.dart';
import 'package:utils_core/utils_core.dart';

class PhonePortField<S> with IsPortFieldWrapper<String, S> {
  @override
  final PortField<String, S> portField;

  final bool isPhone;

  PhonePortField({required PortField<String, S> portField, this.isPhone = true})
      : portField = portField.withValidator(Validator.isPhone().asNonNullable().forPortField());

  @override
  PortField<String, S> copyWith({required String value, required error}) {
    return PhonePortField<S>(
      portField: portField.copyWith(value: value, error: error),
      isPhone: isPhone,
    );
  }
}

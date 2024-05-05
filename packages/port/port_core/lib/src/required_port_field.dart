import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_field_validator_context.dart';
import 'package:utils_core/utils_core.dart';

class RequiredPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final bool isRequired;

  RequiredPortField({required this.portField, this.isRequired = true});

  @override
  Validator<PortFieldValidatorContext, String> get validator =>
      portField.validator + Validator.isNotNull<T>().forPortField();

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return RequiredPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      isRequired: isRequired,
    );
  }
}

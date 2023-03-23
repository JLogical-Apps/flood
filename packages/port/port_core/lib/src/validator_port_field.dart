import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

class ValidatorPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final Validator<T, String> additionalValidator;

  ValidatorPortField({required this.portField, required this.additionalValidator});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return ValidatorPortField(
      portField: portField.copyWith(value: value, error: error),
      additionalValidator: additionalValidator,
    );
  }

  @override
  Validator<T, String> get validator => portField.validator + additionalValidator;
}

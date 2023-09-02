import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_field_validator_context.dart';
import 'package:utils_core/utils_core.dart';

class OptionsPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final List<T> options;

  OptionsPortField({required this.portField, required this.options});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return OptionsPortField(
      portField: portField.copyWith(value: value, error: error),
      options: options,
    );
  }

  @override
  Validator<PortFieldValidatorContext, String> get validator =>
      portField.validator +
      Validator((context) => options.contains(context.value) ? null : '[${context.value}] is not a valid choice!');
}

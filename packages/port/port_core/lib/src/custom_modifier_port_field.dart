import 'package:port_core/src/port_field.dart';

class CustomModifierPortField<T, S, C> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final C customModifier;

  CustomModifierPortField({required this.portField, required this.customModifier});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return CustomModifierPortField<T, S, C>(
      portField: portField.copyWith(value: value, error: error),
      customModifier: customModifier,
    );
  }
}

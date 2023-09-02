import 'package:port_core/src/port_field.dart';

class ColorPortField<T extends int?, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final bool isColor;

  ColorPortField({required this.portField, this.isColor = true});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return ColorPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      isColor: isColor,
    );
  }
}

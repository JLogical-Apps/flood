import 'package:port_core/src/port_field.dart';

class DisplayNamePortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final String displayName;

  DisplayNamePortField({required this.portField, required this.displayName});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return DisplayNamePortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      displayName: displayName,
    );
  }
}

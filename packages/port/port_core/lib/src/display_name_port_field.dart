import 'package:port_core/src/port.dart';
import 'package:port_core/src/port_field.dart';

class DisplayNamePortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final String? Function(Port port) displayNameGetter;

  DisplayNamePortField({required this.portField, required this.displayNameGetter});

  String? getDisplayName() {
    return displayNameGetter(port);
  }

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return DisplayNamePortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      displayNameGetter: displayNameGetter,
    );
  }
}

import 'package:port_core/src/port_field.dart';

class MultilinePortField<S> with IsPortFieldWrapper<String, S> {
  @override
  final PortField<String, S> portField;

  final bool isMultiline;

  MultilinePortField({required this.portField, this.isMultiline = true});

  @override
  PortField<String, S> copyWith({required String value, required error}) {
    return MultilinePortField<S>(
      portField: portField.copyWith(value: value, error: error),
      isMultiline: isMultiline,
    );
  }
}

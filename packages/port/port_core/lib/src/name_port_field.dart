import 'package:port_core/src/port_field.dart';

class NamePortField<S> with IsPortFieldWrapper<String, S> {
  @override
  final PortField<String, S> portField;

  final bool isName;

  NamePortField({required this.portField, this.isName = true});

  @override
  PortField<String, S> copyWith({required String value, required error}) {
    return NamePortField<S>(
      portField: portField.copyWith(value: value, error: error),
      isName: isName,
    );
  }
}

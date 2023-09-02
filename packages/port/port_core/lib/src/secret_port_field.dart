import 'package:port_core/src/port_field.dart';

class SecretPortField<S> with IsPortFieldWrapper<String, S> {
  @override
  final PortField<String, S> portField;

  final bool isSecret;

  SecretPortField({required this.portField, this.isSecret = true});

  @override
  PortField<String, S> copyWith({required String value, required error}) {
    return SecretPortField<S>(
      portField: portField.copyWith(value: value, error: error),
      isSecret: isSecret,
    );
  }
}

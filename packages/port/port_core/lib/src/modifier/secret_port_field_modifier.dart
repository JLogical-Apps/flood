import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/secret_port_field.dart';

class SecretPortFieldNodeModifier extends WrapperPortFieldNodeModifier<SecretPortField> {
  SecretPortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isSecret(SecretPortField portField) {
    return portField.isSecret;
  }
}

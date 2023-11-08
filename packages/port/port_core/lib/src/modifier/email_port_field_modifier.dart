import 'package:port_core/src/email_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class EmailPortFieldNodeModifier extends WrapperPortFieldNodeModifier<EmailPortField> {
  EmailPortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isEmail(EmailPortField portField) {
    return portField.isEmail;
  }
}

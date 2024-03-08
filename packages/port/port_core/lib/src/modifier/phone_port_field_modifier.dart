import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/phone_port_field.dart';

class PhonePortFieldNodeModifier extends WrapperPortFieldNodeModifier<PhonePortField> {
  PhonePortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isPhone(PhonePortField portField) {
    return portField.isPhone;
  }
}

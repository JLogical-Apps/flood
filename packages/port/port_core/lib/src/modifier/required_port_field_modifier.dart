import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/required_port_field.dart';

class RequiredPortFieldNodeModifier extends WrapperPortFieldNodeModifier<RequiredPortField> {
  RequiredPortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isRequired(RequiredPortField portField) {
    return portField.isRequired;
  }
}

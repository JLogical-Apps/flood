import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/name_port_field.dart';

class NamePortFieldNodeModifier extends WrapperPortFieldNodeModifier<NamePortField> {
  NamePortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isName(NamePortField portField) {
    return portField.isName;
  }
}

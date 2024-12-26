import 'package:port_core/src/custom_modifier_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class CustomModifierPortFieldNodeModifier extends WrapperPortFieldNodeModifier<CustomModifierPortField> {
  CustomModifierPortFieldNodeModifier({required super.modifierGetter});

  @override
  C? getCustomModifierOrNull<C>(CustomModifierPortField portField) {
    if (portField.customModifier case final C modifier) {
      return modifier;
    }

    return super.getCustomModifierOrNull(portField);
  }
}

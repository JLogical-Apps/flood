import 'package:port_core/src/display_name_port_field.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_modifier.dart';

class DisplayNamePortFieldNodeModifier extends WrapperPortFieldNodeModifier<DisplayNamePortField> {
  DisplayNamePortFieldNodeModifier({required super.modifierGetter});

  @override
  String? getDisplayNameOrNull(DisplayNamePortField portField) {
    return portField.getDisplayName();
  }
}

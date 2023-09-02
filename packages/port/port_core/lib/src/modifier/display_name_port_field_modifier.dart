import 'package:port_core/src/display_name_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/port.dart';

class DisplayNamePortFieldNodeModifier extends WrapperPortFieldNodeModifier<DisplayNamePortField> {
  DisplayNamePortFieldNodeModifier({required super.modifierGetter});

  @override
  String? getDisplayNameOrNull(Port port, DisplayNamePortField portField) {
    return portField.getDisplayName(port);
  }
}

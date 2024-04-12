import 'package:port_core/src/list_port_field.dart';
import 'package:port_core/src/modifier/port_field_node_modifier.dart';

class ListPortFieldNodeModifier extends PortFieldNodeModifier<ListPortField> {
  @override
  ListPortField? findListPortFieldOrNull(ListPortField portField) {
    return portField;
  }

  @override
  List<R>? getOptionsOrNull<R>(ListPortField portField) {
    if (portField.options != null) {
      return portField.options!.cast<R>();
    }

    return null;
  }
}

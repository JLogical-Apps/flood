import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/port.dart';
import 'package:port_core/src/port_field.dart';

class BasePortFieldModifier extends PortFieldNodeModifier<PortField> {
  @override
  List<R>? getOptionsOrNull<R>(PortField portField) {
    return null;
  }

  @override
  String? getDisplayNameOrNull(Port port, PortField portField) {
    return null;
  }

  @override
  bool isMultiline(PortField portField) {
    return false;
  }
}

import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';

class BasePortFieldWrapper extends PortFieldNodeWrapper<PortField> {
  @override
  List<R>? getOptionsOrNull<R>(PortField portField) {
    return null;
  }

  @override
  String? getDisplayNameOrNull(PortField portField) {
    return null;
  }

  @override
  bool isMultiline(PortField portField) {
    return false;
  }
}

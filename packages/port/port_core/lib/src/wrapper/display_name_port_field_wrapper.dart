import 'package:port_core/src/display_name_port_field.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_wrapper.dart';

class DisplayNamePortFieldNodeWrapper extends WrapperPortFieldNodeWrapper<DisplayNamePortField> {
  DisplayNamePortFieldNodeWrapper({required super.wrapperGetter});

  @override
  String? getDisplayNameOrNull(DisplayNamePortField portField) {
    return portField.getDisplayName();
  }
}

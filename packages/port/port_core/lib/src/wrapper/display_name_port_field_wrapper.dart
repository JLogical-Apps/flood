import 'package:port_core/src/display_name_port_field.dart';
import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';

class DisplayNamePortFieldNodeWrapper extends PortFieldNodeWrapper<DisplayNamePortField> {
  final PortFieldNodeWrapper? Function(PortField portField) wrapperGetter;

  DisplayNamePortFieldNodeWrapper({required this.wrapperGetter});

  @override
  List<R>? getOptionsOrNull<R>(PortFieldWrapper portField) {
    return wrapperGetter(portField.portField)?.getOptionsOrNull(portField.portField);
  }

  @override
  String? getDisplayNameOrNull(DisplayNamePortField portField) {
    return portField.displayName;
  }
}

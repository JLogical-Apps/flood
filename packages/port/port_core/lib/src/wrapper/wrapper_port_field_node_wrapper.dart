import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';

class WrapperPortFieldNodeWrapper extends PortFieldNodeWrapper<PortFieldWrapper> {
  final PortFieldNodeWrapper? Function(PortField portField) wrapperGetter;

  WrapperPortFieldNodeWrapper({required this.wrapperGetter});

  @override
  List<R>? getOptionsOrNull<R>(PortFieldWrapper portField) {
    return wrapperGetter(portField.portField)?.getOptionsOrNull(portField);
  }
}

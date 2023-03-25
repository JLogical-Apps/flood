import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';

class WrapperPortFieldNodeWrapper<T extends PortFieldWrapper> extends PortFieldNodeWrapper<T> {
  final PortFieldNodeWrapper? Function(PortField portField) wrapperGetter;

  WrapperPortFieldNodeWrapper({required this.wrapperGetter});

  @override
  List<R>? getOptionsOrNull<R>(T portField) {
    return wrapperGetter(portField.portField)?.getOptionsOrNull(portField.portField);
  }

  @override
  String? getDisplayNameOrNull(T portField) {
    return wrapperGetter(portField.portField)?.getDisplayNameOrNull(portField.portField);
  }

  @override
  bool isMultiline(T portField) {
    return wrapperGetter(portField.portField)?.isMultiline(portField.portField) ?? false;
  }

  @override
  bool isCurrency(T portField) {
    return wrapperGetter(portField.portField)?.isCurrency(portField.portField) ?? false;
  }
}

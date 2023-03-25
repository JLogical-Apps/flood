import 'package:port_core/src/multiline_port_field.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_wrapper.dart';

class MultilinePortFieldNodeWrapper extends WrapperPortFieldNodeWrapper<MultilinePortField> {
  MultilinePortFieldNodeWrapper({required super.wrapperGetter});

  @override
  bool isMultiline(MultilinePortField portField) {
    return portField.isMultiline;
  }
}

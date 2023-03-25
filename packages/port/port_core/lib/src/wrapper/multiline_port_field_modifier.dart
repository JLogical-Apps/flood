import 'package:port_core/src/multiline_port_field.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_modifier.dart';

class MultilinePortFieldNodeModifier extends WrapperPortFieldNodeModifier<MultilinePortField> {
  MultilinePortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isMultiline(MultilinePortField portField) {
    return portField.isMultiline;
  }
}

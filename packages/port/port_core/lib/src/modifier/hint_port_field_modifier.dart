import 'package:port_core/src/hint_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/port.dart';

class HintPortFieldNodeModifier extends WrapperPortFieldNodeModifier<HintPortField> {
  HintPortFieldNodeModifier({required super.modifierGetter});

  @override
  dynamic getHintOrNull(Port port, HintPortField portField) {
    return portField.getHint();
  }
}

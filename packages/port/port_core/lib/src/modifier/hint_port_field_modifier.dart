import 'package:port_core/src/hint_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class HintPortFieldNodeModifier extends WrapperPortFieldNodeModifier<HintPortField> {
  HintPortFieldNodeModifier({required super.modifierGetter});

  @override
  String? getHintOrNull(HintPortField portField) {
    return portField.getHint();
  }
}

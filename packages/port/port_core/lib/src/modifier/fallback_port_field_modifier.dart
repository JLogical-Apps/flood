import 'package:port_core/src/fallback_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class FallbackPortFieldNodeModifier extends WrapperPortFieldNodeModifier<FallbackPortField> {
  FallbackPortFieldNodeModifier({required super.modifierGetter});

  @override
  dynamic getHintOrNull(FallbackPortField portField) {
    return portField.getFallback();
  }
}

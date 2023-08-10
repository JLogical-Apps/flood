import 'package:port_core/src/fallback_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/port.dart';

class FallbackPortFieldNodeModifier extends WrapperPortFieldNodeModifier<FallbackPortField> {
  FallbackPortFieldNodeModifier({required super.modifierGetter});

  @override
  dynamic getHintOrNull(Port port, FallbackPortField portField) {
    return portField.getFallback(port);
  }
}

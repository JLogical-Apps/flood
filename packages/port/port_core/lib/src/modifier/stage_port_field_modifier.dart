import 'package:port_core/port_core.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class StagePortFieldNodeModifier extends WrapperPortFieldNodeModifier<StagePortField> {
  StagePortFieldNodeModifier({required super.modifierGetter});

  @override
  List<R>? getOptionsOrNull<R>(StagePortField portField) {
    return portField.options.cast<R>();
  }

  @override
  StagePortField? findStagePortFieldOrNull(StagePortField portField) {
    return portField;
  }
}

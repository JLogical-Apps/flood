import 'package:port_core/port_core.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class DatePortFieldNodeModifier extends WrapperPortFieldNodeModifier<DatePortField> {
  DatePortFieldNodeModifier({required super.modifierGetter});

  @override
  DatePortField? findDatePortFieldOrNull(DatePortField portField) {
    return portField;
  }
}

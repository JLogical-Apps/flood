import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/options_port_field.dart';

class OptionsPortFieldNodeModifier extends PortFieldNodeModifier<OptionsPortField> {
  @override
  List<R>? getOptionsOrNull<R>(OptionsPortField portField) {
    return portField.options.cast<R>();
  }
}

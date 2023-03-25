import 'package:port_core/src/options_port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_modifier.dart';

class OptionsPortFieldNodeModifier extends PortFieldNodeModifier<OptionsPortField> {
  @override
  List<R>? getOptionsOrNull<R>(OptionsPortField portField) {
    return portField.options.cast<R>();
  }
}

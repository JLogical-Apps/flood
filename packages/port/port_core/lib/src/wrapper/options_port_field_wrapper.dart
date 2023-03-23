import 'package:port_core/src/options_port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';

class OptionsPortFieldNodeWrapper extends PortFieldNodeWrapper<OptionsPortField> {
  @override
  List<R>? getOptionsOrNull<R>(OptionsPortField portField) {
    return portField.options.cast<R>();
  }

  @override
  String? getDisplayNameOrNull(OptionsPortField portField) {
    return null;
  }
}

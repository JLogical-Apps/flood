import 'package:port_core/src/map_port_field.dart';
import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';

class MapPortFieldNodeWrapper extends PortFieldNodeWrapper<MapPortField> {
  final PortFieldNodeWrapper? Function(PortField portField) wrapperGetter;

  MapPortFieldNodeWrapper({required this.wrapperGetter});

  @override
  List<R>? getOptionsOrNull<R>(MapPortField portField) {
    return wrapperGetter(portField.portField)?.getOptionsOrNull(portField.portField);
  }

  @override
  String? getDisplayNameOrNull(MapPortField portField) {
    return wrapperGetter(portField.portField)?.getDisplayNameOrNull(portField.portField);
  }

  @override
  bool isMultiline(MapPortField portField) {
    return wrapperGetter(portField.portField)?.isMultiline(portField.portField) ?? false;
  }

  @override
  bool isCurrency(MapPortField portField) {
    return wrapperGetter(portField.portField)?.isCurrency(portField.portField) ?? false;
  }
}

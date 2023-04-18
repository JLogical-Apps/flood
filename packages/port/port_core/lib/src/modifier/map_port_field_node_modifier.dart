import 'package:port_core/src/map_port_field.dart';
import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/port_field.dart';

class MapPortFieldNodeModifier extends PortFieldNodeModifier<MapPortField> {
  final PortFieldNodeModifier? Function(PortField portField) modifierGetter;

  MapPortFieldNodeModifier({required this.modifierGetter});

  @override
  List<R>? getOptionsOrNull<R>(MapPortField portField) {
    return modifierGetter(portField.portField)?.getOptionsOrNull(portField.portField);
  }

  @override
  String? getDisplayNameOrNull(MapPortField portField) {
    return modifierGetter(portField.portField)?.getDisplayNameOrNull(portField.portField);
  }

  @override
  bool isMultiline(MapPortField portField) {
    return modifierGetter(portField.portField)?.isMultiline(portField.portField) ?? false;
  }

  @override
  bool isCurrency(MapPortField portField) {
    return modifierGetter(portField.portField)?.isCurrency(portField.portField) ?? false;
  }

  @override
  bool isOnlyDate(MapPortField portField) {
    return modifierGetter(portField.portField)?.isOnlyDate(portField.portField) ?? false;
  }
}

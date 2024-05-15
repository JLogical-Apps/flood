import 'package:asset_core/asset_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_core/src/map_port_field.dart';
import 'package:port_core/src/modifier/port_field_node_modifier.dart';

class MapPortFieldNodeModifier extends PortFieldNodeModifier<MapPortField> {
  final PortFieldNodeModifier? Function(PortField portField) modifierGetter;

  MapPortFieldNodeModifier({required this.modifierGetter});

  @override
  List<R>? getOptionsOrNull<R>(MapPortField portField) {
    return modifierGetter(portField.portField)?.getOptionsOrNull(portField.portField);
  }

  @override
  SearchPortField? findSearchPortFieldOrNull(MapPortField portField) {
    return modifierGetter(portField.portField)?.findSearchPortFieldOrNull(portField.portField);
  }

  @override
  AllowedFileTypes? getAllowedFileTypes(MapPortField portField) {
    return modifierGetter(portField.portField)?.getAllowedFileTypes(portField.portField);
  }

  @override
  String? getDisplayNameOrNull(MapPortField portField) {
    return modifierGetter(portField.portField)?.getDisplayNameOrNull(portField.portField);
  }

  @override
  bool isRequired(MapPortField portField) {
    return modifierGetter(portField.portField)?.isRequired(portField.portField) ?? false;
  }

  @override
  bool isMultiline(MapPortField portField) {
    return modifierGetter(portField.portField)?.isMultiline(portField.portField) ?? false;
  }

  @override
  bool isSecret(MapPortField portField) {
    return modifierGetter(portField.portField)?.isSecret(portField.portField) ?? false;
  }

  @override
  bool isCurrency(MapPortField portField) {
    return modifierGetter(portField.portField)?.isCurrency(portField.portField) ?? false;
  }

  @override
  bool isColor(MapPortField portField) {
    return modifierGetter(portField.portField)?.isColor(portField.portField) ?? false;
  }

  @override
  bool isOnlyDate(MapPortField portField) {
    return modifierGetter(portField.portField)?.isOnlyDate(portField.portField) ?? false;
  }

  @override
  bool isPhone(MapPortField portField) {
    return modifierGetter(portField.portField)?.isPhone(portField.portField) ?? false;
  }

  @override
  bool isEmail(MapPortField portField) {
    return modifierGetter(portField.portField)?.isEmail(portField.portField) ?? false;
  }

  @override
  bool isName(MapPortField portField) {
    return modifierGetter(portField.portField)?.isName(portField.portField) ?? false;
  }

  @override
  dynamic getHintOrNull(MapPortField portField) {
    return modifierGetter(portField.portField)?.getHintOrNull(portField.portField);
  }
}

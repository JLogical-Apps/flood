import 'package:asset_core/asset_core.dart';
import 'package:port_core/src/asset_port_field.dart';
import 'package:port_core/src/date_port_field.dart';
import 'package:port_core/src/list_port_field.dart';
import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/search_port_field.dart';
import 'package:port_core/src/stage_port_field.dart';

class WrapperPortFieldNodeModifier<T extends PortFieldWrapper> extends PortFieldNodeModifier<T> {
  final PortFieldNodeModifier? Function(PortField portField) modifierGetter;

  WrapperPortFieldNodeModifier({required this.modifierGetter});

  @override
  List<R>? getOptionsOrNull<R>(T portField) {
    return modifierGetter(portField.portField)?.getOptionsOrNull(portField.portField);
  }

  @override
  AllowedFileTypes? getAllowedFileTypes(T portField) {
    return modifierGetter(portField.portField)?.getAllowedFileTypes(portField.portField);
  }

  @override
  String? getDisplayNameOrNull(T portField) {
    return modifierGetter(portField.portField)?.getDisplayNameOrNull(portField.portField);
  }

  @override
  dynamic getHintOrNull(T portField) {
    return modifierGetter(portField.portField)?.getHintOrNull(portField.portField);
  }

  @override
  bool isRequired(T portField) {
    return modifierGetter(portField.portField)?.isRequired(portField.portField) ?? false;
  }

  @override
  bool isMultiline(T portField) {
    return modifierGetter(portField.portField)?.isMultiline(portField.portField) ?? false;
  }

  @override
  bool isName(T portField) {
    return modifierGetter(portField.portField)?.isName(portField.portField) ?? false;
  }

  @override
  bool isEmail(T portField) {
    return modifierGetter(portField.portField)?.isEmail(portField.portField) ?? false;
  }

  @override
  bool isPhone(T portField) {
    return modifierGetter(portField.portField)?.isPhone(portField.portField) ?? false;
  }

  @override
  bool isSecret(T portField) {
    return modifierGetter(portField.portField)?.isSecret(portField.portField) ?? false;
  }

  @override
  bool isCurrency(T portField) {
    return modifierGetter(portField.portField)?.isCurrency(portField.portField) ?? false;
  }

  @override
  bool isColor(T portField) {
    return modifierGetter(portField.portField)?.isColor(portField.portField) ?? false;
  }

  @override
  bool isOnlyDate(T portField) {
    return modifierGetter(portField.portField)?.isOnlyDate(portField.portField) ?? false;
  }

  @override
  StagePortField? findStagePortFieldOrNull(T portField) {
    return modifierGetter(portField.portField)?.findStagePortFieldOrNull(portField.portField);
  }

  @override
  AssetPortField? findAssetPortFieldOrNull(T portField) {
    return modifierGetter(portField.portField)?.findAssetPortFieldOrNull(portField.portField);
  }

  @override
  DatePortField? findDatePortFieldOrNull(T portField) {
    return modifierGetter(portField.portField)?.findDatePortFieldOrNull(portField.portField);
  }

  @override
  ListPortField? findListPortFieldOrNull(T portField) {
    return modifierGetter(portField.portField)?.findListPortFieldOrNull(portField.portField);
  }

  @override
  SearchPortField? findSearchPortFieldOrNull(T portField) {
    return modifierGetter(portField.portField)?.findSearchPortFieldOrNull(portField.portField);
  }
}

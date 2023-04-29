import 'package:port_core/port_core.dart';
import 'package:port_core/src/modifier/base_port_field_modifier.dart';
import 'package:port_core/src/modifier/currency_port_field_modifier.dart';
import 'package:port_core/src/modifier/date_port_field_modifier.dart';
import 'package:port_core/src/modifier/display_name_port_field_modifier.dart';
import 'package:port_core/src/modifier/fallback_port_field_modifier.dart';
import 'package:port_core/src/modifier/hint_port_field_modifier.dart';
import 'package:port_core/src/modifier/map_port_field_node_modifier.dart';
import 'package:port_core/src/modifier/multiline_port_field_modifier.dart';
import 'package:port_core/src/modifier/options_port_field_modifier.dart';
import 'package:port_core/src/modifier/stage_port_field_modifier.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortFieldNodeModifier<T extends PortField<dynamic, dynamic>>
    with IsTypedModifier<T, PortField<dynamic, dynamic>> {
  List<R>? getOptionsOrNull<R>(T portField) {
    return null;
  }

  String? getDisplayNameOrNull(T portField) {
    return null;
  }

  dynamic getHintOrNull(T portField) {
    return null;
  }

  bool isMultiline(T portField) {
    return false;
  }

  bool isCurrency(T portField) {
    return false;
  }

  bool isOnlyDate(T portField) {
    return false;
  }

  StagePortField? findStagePortFieldOrNull(T portField) {
    return null;
  }

  DatePortField? findDatePortFieldOrNull(T portField) {
    return null;
  }

  static final nodeModifierResolver = ModifierResolver<PortFieldNodeModifier, PortField>(modifiers: [
    OptionsPortFieldNodeModifier(),
    StagePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    DatePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    DisplayNamePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    MultilinePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    CurrencyPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    FallbackPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    HintPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    WrapperPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    MapPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    BasePortFieldModifier(),
  ]);

  static PortFieldNodeModifier? getModifierOrNull(PortField portField) {
    return nodeModifierResolver.resolveOrNull(portField);
  }
}

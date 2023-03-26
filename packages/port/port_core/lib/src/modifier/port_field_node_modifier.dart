import 'package:port_core/port_core.dart';
import 'package:port_core/src/modifier/base_port_field_modifier.dart';
import 'package:port_core/src/modifier/currency_port_field_modifier.dart';
import 'package:port_core/src/modifier/display_name_port_field_modifier.dart';
import 'package:port_core/src/modifier/interface_port_field_modifier.dart';
import 'package:port_core/src/modifier/map_port_field_node_modifier.dart';
import 'package:port_core/src/modifier/multiline_port_field_modifier.dart';
import 'package:port_core/src/modifier/options_port_field_modifier.dart';
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

  bool isMultiline(T portField) {
    return false;
  }

  bool isCurrency(T portField) {
    return false;
  }

  InterfacePortField? findInterfacePortFieldOrNull(T portField) {
    return null;
  }

  static final nodeModifierResolver = ModifierResolver<PortFieldNodeModifier, PortField>(modifiers: [
    OptionsPortFieldNodeModifier(),
    InterfacePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    DisplayNamePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    MultilinePortFieldNodeModifier(modifierGetter: getModifierOrNull),
    CurrencyPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    WrapperPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    MapPortFieldNodeModifier(modifierGetter: getModifierOrNull),
    BasePortFieldModifier(),
  ]);

  static PortFieldNodeModifier? getModifierOrNull(PortField portField) {
    return nodeModifierResolver.resolveOrNull(portField);
  }
}

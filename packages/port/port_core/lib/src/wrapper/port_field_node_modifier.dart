import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/base_port_field_modifier.dart';
import 'package:port_core/src/wrapper/currency_port_field_modifier.dart';
import 'package:port_core/src/wrapper/display_name_port_field_modifier.dart';
import 'package:port_core/src/wrapper/map_port_field_node_modifier.dart';
import 'package:port_core/src/wrapper/multiline_port_field_modifier.dart';
import 'package:port_core/src/wrapper/options_port_field_modifier.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_modifier.dart';
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

  static final nodeModifierResolver = ModifierResolver<PortFieldNodeModifier, PortField>(modifiers: [
    OptionsPortFieldNodeModifier(),
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

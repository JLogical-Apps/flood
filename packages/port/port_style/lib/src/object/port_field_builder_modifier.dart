import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/currency_port_field_builder_modifier.dart';
import 'package:port_style/src/object/string_port_field_builder_modifier.dart';
import 'package:utils/utils.dart';

abstract class PortFieldBuilderModifier with IsModifier<PortField> {
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField);

  static final portFieldBuilderModifierResolver = ModifierResolver<PortFieldBuilderModifier, PortField>(modifiers: [
    StringPortFieldBuilderModifier(),
    CurrencyPortFieldBuilderModifier(),
  ]);

  static PortFieldBuilderModifier? getPortFieldBuilderModifier(PortField portField) {
    return portFieldBuilderModifierResolver.resolveOrNull(portField);
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_double_port_field.dart';
import 'package:utils/utils.dart';

class DoublePortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(PortField portField) {
    return StyledDoubleFieldPortField(
      fieldPath: portField.fieldPath,
      labelText: portField.findDisplayNameOrNull(),
      hintText: (portField.findHintOrNull() as Object?)?.as<double>()?.formatIntOrDouble(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == double || input.dataType == typeOf<double?>();
  }
}

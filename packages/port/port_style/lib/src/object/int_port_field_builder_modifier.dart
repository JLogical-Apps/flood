import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_int_port_field.dart';
import 'package:utils/utils.dart';

class IntPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(PortField portField) {
    return StyledIntFieldPortField(
      fieldPath: portField.fieldPath,
      labelText: portField.findDisplayNameOrNull(),
      hintText: (portField.findHintOrNull() as Object?)?.as<int>()?.formatIntOrDouble(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == int || input.dataType == typeOf<int?>();
  }
}

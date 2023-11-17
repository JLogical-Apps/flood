import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_bool_port_field.dart';
import 'package:utils/utils.dart';

class BoolPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledBoolFieldPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == bool || input.dataType == typeOf<bool?>();
  }
}

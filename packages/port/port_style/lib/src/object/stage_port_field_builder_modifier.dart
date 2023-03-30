import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';

class StagePortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledStagePortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findStageFieldOrNull() != null;
  }
}

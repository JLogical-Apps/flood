import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_color_picker_port_field.dart';

class ColorPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledColorPickerPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(port),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findIsColor();
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_multi_option_port_field.dart';

class MultiOptionPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledMultiOptionPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findListFieldOrNull() != null && input.findOptionsOrNull() != null;
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';

class StringPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledTextFieldPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(),
      maxLines: portField.findIsMultiline() ? 3 : 1,
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input is PortField<String?, String?>;
  }
}

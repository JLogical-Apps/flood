import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:utils/utils.dart';

class StringPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(PortField portField) {
    return StyledTextFieldPortField(
      fieldPath: portField.fieldPath,
      labelText: portField.findDisplayNameOrNull(),
      maxLines: portField.findIsMultiline() ? 3 : 1,
      hintText: portField.findHintOrNull()?.toString(),
      obscureText: portField.findIsSecret(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == String || input.dataType == typeOf<String?>();
  }
}

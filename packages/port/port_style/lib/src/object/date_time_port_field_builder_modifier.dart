import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:utils/utils.dart';

class DateTimePortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(PortField portField) {
    return StyledDateTimeFieldPortField(
      fieldPath: portField.fieldPath,
      labelText: portField.findDisplayNameOrNull(),
      hintText: portField.findHintOrNull()?.toString(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == DateTime || input.dataType == typeOf<DateTime?>();
  }
}

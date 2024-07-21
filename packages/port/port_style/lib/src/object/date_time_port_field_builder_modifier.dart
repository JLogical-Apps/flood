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
      hintText: getHintText(portField),
    );
  }

  String? getHintText(PortField portField) {
    final hint = portField.findHintOrNull();
    final dateField = portField.findDateFieldOrNull();
    final dateOnly = dateField?.isTime == false;

    if (hint == null) {
      return null;
    }

    if (hint is DateTime) {
      return hint.formatWith((dateFormat) {
        if (dateOnly) {
          return dateFormat.addPattern('MM/dd/yyyy');
        } else {
          return dateFormat.addPattern('MM/dd/yyyy h:mm a');
        }
      });
    }

    return null;
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == DateTime || input.dataType == typeOf<DateTime?>();
  }
}

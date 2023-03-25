import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_wrapper.dart';

class StringPortFieldBuilderWrapper extends PortFieldBuilderWrapper {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledTextFieldPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(),
      maxLines: portField.findIsMultiline() ? 3 : null,
    );
  }

  @override
  bool shouldWrap(PortField input) {
    return input.dataType == String;
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:utils/utils.dart';

class OptionsPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledOptionPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(port),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findOptionsOrNull() != null;
  }
}

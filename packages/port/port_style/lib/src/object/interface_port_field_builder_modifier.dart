import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:style/style.dart';

class InterfacePortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledList.column(
      children: [
        StyledOptionPortField(
          fieldName: fieldName,
          labelText: portField.findDisplayNameOrNull(),
          widgetMapper: (valueObject) => StyledText.button(valueObject.runtimeType.toString()),
        ),
      ],
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findOptionsOrNull() != null;
  }
}

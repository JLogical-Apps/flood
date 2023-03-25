import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_wrapper.dart';

class CurrencyPortFieldBuilderWrapper extends PortFieldBuilderWrapper {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledCurrencyFieldPortField(
      fieldName: fieldName,
      labelText: portField.findDisplayNameOrNull(),
    );
  }

  @override
  bool shouldWrap(PortField input) {
    return input.findIsCurrency();
  }
}

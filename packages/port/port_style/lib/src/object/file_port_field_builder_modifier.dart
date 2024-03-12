import 'package:flutter/material.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_file_port_field.dart';
import 'package:utils/utils.dart';

class FilePortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    return StyledFilePortField(
      fieldName: fieldName,
      allowedFileTypes: portField.findAllowedFileTypes(),
      labelText: portField.findDisplayNameOrNull(),
      hintText: portField.findHintOrNull()?.toString(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == CrossFile || input.dataType == typeOf<CrossFile?>();
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_asset_port_field.dart';

class AssetPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(PortField portField) {
    return StyledAssetPortField(
      fieldPath: portField.fieldPath,
      labelText: portField.findDisplayNameOrNull(),
      allowedFileTypes: portField.findAllowedFileTypes(),
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findAssetFieldOrNull() != null;
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:port_style/src/styled_search_port_field.dart';

class SearchPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(PortField portField) {
    final searchField = portField.findSearchFieldOrNull()!;
    return StyledSearchPortField(
      fieldPath: portField.fieldPath,
      labelText: portField.findDisplayNameOrNull(),
      stringSearchMapper: !searchField.hasStringSearch ? null : searchField.getSearchString,
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.findSearchFieldOrNull() != null;
  }
}

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:style/style.dart';

class EmbeddedPortFieldBuilderModifier extends PortFieldBuilderModifier {
  @override
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField) {
    final displayName = portField.findDisplayNameOrNull();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayName != null)
          Padding(
            padding: const EdgeInsets.all(4),
            child: StyledText.body.bold.display(displayName),
          ),
        StyledCard(
          children: [
            StyledObjectPortBuilder(port: portField.value as Port),
          ],
        ),
      ],
    );
  }

  @override
  bool shouldModify(PortField input) {
    return input.dataType == Port;
  }
}

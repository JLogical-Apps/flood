import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_wrapper.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledObjectPortBuilder extends HookWidget {
  final Port port;

  StyledObjectPortBuilder({required this.port});

  @override
  Widget build(BuildContext context) {
    return PortBuilder(
      port: port,
      builder: (context, port) {
        final portFieldByName = port.portFieldByName;
        return StyledList.column(
          children: portFieldByName
              .mapToIterable((name, portField) =>
                  PortFieldBuilderWrapper.getPortFieldBuilderWrapper(portField)?.getWidgetOrNull(port, name, portField))
              .whereNonNull()
              .toList(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:port_style/src/styled_object_port_builder.dart';

class StyledObjectPortField<T> extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final List<String> order;

  const StyledObjectPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
    this.enabled = true,
    this.order = const [],
  });

  @override
  Widget build(BuildContext context) {
    return PortFieldBuilder<Port<T>?>(
      fieldPath: fieldPath,
      builder: (context, field, objectPort, error) {
        if (objectPort == null) {
          return Container();
        }

        return StyledObjectPortBuilder(
          port: objectPort,
          order: order,
        );
      },
    );
  }
}

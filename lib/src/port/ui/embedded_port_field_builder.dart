import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/port/ui/port_field_widget.dart';
import 'package:jlogical_utils/src/port/ui/port_update_builder.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import '../model/port.dart';
import '../model/fields/embedded_port_field.dart';

class EmbeddedPortFieldBuilder extends PortFieldWidget<EmbeddedPortField, Port, Port> {
  final Widget Function(Port port, EmbeddedPortField field) builder;

  EmbeddedPortFieldBuilder({super.key, required super.name, required this.builder});

  Widget buildField(BuildContext context, EmbeddedPortField field, Port value, Object? exception) {
    useValueStream(useMemoized(() => field.enabledX));
    return PortUpdateBuilder(
      builder: (port) => builder(port, field),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EmbeddedPortFieldBuilder extends PortFieldWidget<EmbeddedPortField, Port> {
  final Widget Function(Port port, EmbeddedPortField field) builder;

  EmbeddedPortFieldBuilder({super.key, required super.name, required this.builder});

  Widget buildField(BuildContext context, EmbeddedPortField field, Port value, Object? exception) {
    useValueStream(useMemoized(() => field.enabledX));
    return PortUpdateBuilder(
      builder: (port) => builder(port, field),
    );
  }
}

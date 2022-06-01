import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EmbeddedPortFieldBuilder extends HookWidget {
  final EmbeddedPortField embeddedPortField;

  final Widget Function(Port port, EmbeddedPortField field) builder;

  const EmbeddedPortFieldBuilder({super.key, required this.embeddedPortField, required this.builder});

  @override
  Widget build(BuildContext context) {
    useValueStream(useMemoized(() => embeddedPortField.enabledX));

    return PortUpdateBuilder(
      builder: (port) => builder(port, embeddedPortField),
    );
  }
}

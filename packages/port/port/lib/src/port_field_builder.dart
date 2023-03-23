import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port_core/port_core.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

class PortFieldBuilder<T> extends HookWidget {
  final String fieldName;
  final Widget Function(BuildContext context, PortField portField, T value, dynamic error) builder;

  const PortFieldBuilder({super.key, required this.fieldName, required this.builder});

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    useValueStream(port.getPortX());
    return builder(
      context,
      port.getFieldByName(fieldName),
      port[fieldName],
      port.getErrorByName(fieldName),
    );
  }
}

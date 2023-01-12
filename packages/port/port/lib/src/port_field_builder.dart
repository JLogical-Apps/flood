import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port_core/port_core.dart';
import 'package:provider/provider.dart';

class PortFieldBuilder<T> extends HookWidget {
  final String fieldName;
  final Widget Function(BuildContext context, T value, dynamic error) builder;

  const PortFieldBuilder({super.key, required this.fieldName, required this.builder});

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return builder(context, port[fieldName], port.getErrorByName(fieldName));
  }
}

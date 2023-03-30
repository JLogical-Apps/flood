import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

class PortBuilder<T> extends HookWidget {
  final Port<T> port;
  final Widget Function(BuildContext context, Port<T> port) builder;

  PortBuilder({super.key, required this.port, required this.builder});

  @override
  Widget build(BuildContext context) {
    useValueStream(port.getPortX());

    return Provider<Port>(
      create: (_) => port,
      child: builder(context, port),
    );
  }
}

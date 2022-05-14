import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/port.dart';

class PortBuilder extends StatelessWidget {
  final Port port;

  final Widget child;

  PortBuilder({
    super.key,
    required this.port,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => port,
      child: child,
    );
  }
}

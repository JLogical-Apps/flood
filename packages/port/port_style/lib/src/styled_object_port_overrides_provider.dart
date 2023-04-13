import 'package:flutter/material.dart';
import 'package:port_style/src/styled_object_port_overrides.dart';
import 'package:provider/provider.dart';

class StyledObjectPortOverridesProvider extends StatelessWidget {
  final StyledObjectPortOverrides overrides;
  final Widget child;

  StyledObjectPortOverridesProvider({required this.overrides, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<StyledObjectPortOverrides>(
      create: (_) => overrides,
      child: child,
    );
  }
}

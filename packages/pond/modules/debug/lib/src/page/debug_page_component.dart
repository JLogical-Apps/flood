import 'package:flutter/material.dart';

abstract class DebugPageComponent {
  String get name;

  Widget render(BuildContext context);
}

mixin IsDebugPageComponent implements DebugPageComponent {}

abstract class DebugPageComponentWrapper implements DebugPageComponent {
  DebugPageComponent get debugPageComponent;
}

mixin IsDebugPageComponentWrapper implements DebugPageComponentWrapper {
  @override
  String get name => debugPageComponent.name;

  @override
  Widget render(BuildContext context) => debugPageComponent.render(context);
}

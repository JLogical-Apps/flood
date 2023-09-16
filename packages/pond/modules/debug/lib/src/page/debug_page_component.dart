import 'package:flutter/material.dart' hide Route;
import 'package:pond/pond.dart';

abstract class DebugPageComponent {
  String get name;

  String get description;

  Widget get icon;

  Route get route;
}

mixin IsDebugPageComponent implements DebugPageComponent {}

abstract class DebugPageComponentWrapper implements DebugPageComponent {
  DebugPageComponent get debugPageComponent;
}

mixin IsDebugPageComponentWrapper implements DebugPageComponentWrapper {
  @override
  String get name => debugPageComponent.name;

  @override
  String get description => debugPageComponent.description;

  @override
  Widget get icon => debugPageComponent.icon;

  @override
  Route get route => debugPageComponent.route;
}

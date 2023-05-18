import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

abstract class DebugPageComponent {
  String get name;

  String get description;

  Widget get icon;

  AppPage get appPage;
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
  AppPage get appPage => debugPageComponent.appPage;
}

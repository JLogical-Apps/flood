import 'package:pond/pond.dart';

abstract class DebugPageComponent {
  String get name;

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
  AppPage get appPage => debugPageComponent.appPage;
}

import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:port_style/port_style.dart';

class PortStyleComponent with IsAppPondComponent {
  final List<StyledObjectPortOverride> overrides;

  PortStyleComponent({this.overrides = const []});

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return StyledObjectPortOverridesProvider(
      overrides: StyledObjectPortOverrides(overrides: overrides),
      child: app,
    );
  }
}

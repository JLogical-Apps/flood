import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class EnvironmentBannerAppComponent extends AppPondComponent {
  @override
  Widget wrapApp(Widget app) {
    return Banner(
      message: 'Test!',
      location: BannerLocation.topEnd,
      child: app,
    );
  }
}

import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class EnvironmentBannerAppComponent extends AppPondComponent {
  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return Banner(
      message: context.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
      child: app,
    );
  }
}

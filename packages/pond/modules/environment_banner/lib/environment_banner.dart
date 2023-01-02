import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class EnvironmentBannerAppComponent with IsAppPondComponent {
  @override
  Widget wrapPage(AppPondContext context, Widget page) {
    return Banner(
      message: context.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
      child: page,
    );
  }
}

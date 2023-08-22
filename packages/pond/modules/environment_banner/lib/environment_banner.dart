import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class EnvironmentBannerAppComponent with IsAppPondComponent {
  final bool Function(EnvironmentType environmentType)? shouldShow;

  EnvironmentBannerAppComponent({this.shouldShow});

  @override
  Widget wrapPage(AppPondContext context, Widget page, AppPondPageContext pageContext) {
    final shouldShow = this.shouldShow ?? (environment) => environment != EnvironmentType.static.production;
    if (!shouldShow(context.environment)) {
      return page;
    }

    return Banner(
      message: context.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
      child: page,
    );
  }
}

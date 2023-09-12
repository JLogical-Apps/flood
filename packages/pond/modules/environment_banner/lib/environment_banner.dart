import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class EnvironmentBannerAppComponent with IsAppPondComponent {
  final bool Function()? shouldShow;

  EnvironmentBannerAppComponent({this.shouldShow});

  @override
  Widget wrapPage(AppPondContext context, Widget page, AppPondPageContext pageContext) {
    final shouldShow = this.shouldShow ?? () => context.buildType != BuildType.release;
    if (!shouldShow()) {
      return page;
    }

    return Banner(
      message: context.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
      child: page,
    );
  }
}

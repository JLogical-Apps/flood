import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>(
        builder: (context, route) => Container(),
      ).withRedirect((context, route) {
        final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
        if (loggedInUserId == null) {
          return LoginRoute().uri;
        } else {
          return ProfileRoute().uri;
        }
      });
}

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

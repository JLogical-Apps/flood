import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage with IsAppPage<HomeRoute> {
  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    if (loggedInUserId == null) {
      return LoginPage().build(context, LoginRoute());
    } else {
      return ProfilePage().build(context, ProfileRoute());
    }
  }
}

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

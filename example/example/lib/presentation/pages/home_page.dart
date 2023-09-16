import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage<HomeRoute> {
  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    return LoginPage().onBuild(context, LoginRoute());
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

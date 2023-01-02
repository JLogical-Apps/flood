import 'dart:async';

import 'package:example/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('home');

  @override
  Widget build(BuildContext context) {
    final loggedInUser =
        useFuture(useMemoized(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUser()));

    return StyledPage(
      titleText: 'Home',
      body: Center(
        child: StyledText.h1('Welcome ${loggedInUser.hasData ? loggedInUser.data : '...'}'),
      ),
    );
  }

  @override
  AppPage copy() {
    return HomePage();
  }

  @override
  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) async {
    final loggedInUser = await context.appPondContext.find<AuthCoreComponent>().getLoggedInUser();
    if (loggedInUser == null) {
      final redirectUri = currentUri.toString() == '/' ? null : currentUri;
      final loginPage = LoginPage()..redirectPathProperty.set(redirectUri?.toString());
      return loginPage.uri;
    }

    return null;
  }
}

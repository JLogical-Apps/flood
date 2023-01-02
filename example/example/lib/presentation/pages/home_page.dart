import 'dart:async';

import 'package:example/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('home');

  @override
  Widget build(BuildContext context) {
    final loggedInUserIdModel =
        useFutureModel(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId());
    return StyledPage(
      titleText: 'Home',
      body: Center(
        child: ModelBuilder<String?>(
          model: loggedInUserIdModel,
          loadingIndicator: StyledLoadingIndicator(),
          builder: (userId) {
            return StyledText.h1('Welcome ${userId!.substring(0, 2)}!');
          },
        ),
      ),
    );
  }

  @override
  AppPage copy() {
    return HomePage();
  }

  @override
  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) async {
    final loggedInUser = await context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId();
    if (loggedInUser == null) {
      final loginPage = LoginPage()..redirectPathProperty.set(currentUri.toString());
      return loginPage.uri;
    }

    return null;
  }
}

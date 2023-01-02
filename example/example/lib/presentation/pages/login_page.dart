import 'dart:async';

import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LoginPage extends AppPage {
  late final redirectPathProperty = field<String>(name: 'redirect');

  @override
  Widget build(BuildContext context) {
    final emailState = useState<String>('');
    final passwordState = useState<String>('');

    return StyledPage(
      body: StyledList.column.centered.withScrollbar(
        children: [
          StyledImage.asset('assets/logo_foreground.png', width: 200, height: 200),
          StyledText.h1.strong('Welcome to Valet'),
          StyledDivider(),
          StyledTextField(
            labelText: 'Email',
            text: emailState.value,
            onChanged: (text) => emailState.value = text,
          ),
          StyledTextField(
            labelText: 'Password',
            text: passwordState.value,
            onChanged: (text) => passwordState.value = text,
          ),
          StyledList.row.centered.withScrollbar(children: [
            StyledButton(
              labelText: 'Login',
              onPressed: () async {
                final email = emailState.value;
                final password = passwordState.value;

                await context.appPondContext.find<AuthCoreComponent>().login(email, password);
                context.warpTo(HomePage());
              },
            ),
            StyledButton.strong(
              labelText: 'Sign Up',
              onPressed: () async {
                final email = emailState.value;
                final password = passwordState.value;

                await context.appPondContext.find<AuthCoreComponent>().signup(email, password);
                context.warpTo(HomePage());
              },
            ),
          ]),
        ],
      ),
    );
  }

  @override
  AppPage copy() {
    return LoginPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('login');

  @override
  List<RouteProperty> get queryProperties => [redirectPathProperty];

  @override
  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) async {
    final loggedInUser = await context.appPondContext.find<AuthCoreComponent>().getLoggedInUser();
    if (loggedInUser != null) {
      if (redirectPathProperty.value != null) {
        return Uri.parse(redirectPathProperty.value!);
      } else {
        final homePage = HomePage();
        return homePage.uri;
      }
    }

    return null;
  }
}

import 'dart:async';

import 'package:example/presentation/pages/home_page.dart';
import 'package:example_core/example_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LoginPage extends AppPage {
  late final redirectPathProperty = field<String>(name: 'redirect');

  @override
  Widget build(BuildContext context) {
    final loginPort = useMemoized(() => Port.of({
          'email': PortField.string().isNotBlank().isEmail(),
          'password': PortField.string().isNotBlank(),
        }));

    return StyledPage(
      body: PortBuilder(
        port: loginPort,
        builder: (context, port) {
          return StyledList.column.centered.withScrollbar(
            children: [
              StyledImage.asset('assets/logo_foreground.png', width: 200, height: 200),
              StyledText.h1.strong('Welcome to Valet'),
              StyledDivider(),
              StyledTextFieldPortField(
                fieldName: 'email',
                labelText: 'Email',
              ),
              StyledTextFieldPortField(
                fieldName: 'password',
                labelText: 'Password',
                obscureText: true,
              ),
              StyledList.row.centered.withScrollbar(
                children: [
                  StyledButton(
                    labelText: 'Login',
                    onPressed: () async {
                      final result = await loginPort.submit();
                      if (!result.isValid) {
                        return;
                      }

                      final data = result.data;

                      try {
                        await context.find<AuthCoreComponent>().login(data['email'], data['password']);
                        context.warpTo(HomePage());
                      } catch (e, stackTrace) {
                        final errorText = e.as<LoginFailure>()?.displayText ?? e.toString();
                        loginPort.setError(name: 'email', error: errorText);
                        context.logError(e, stackTrace);
                      }
                    },
                  ),
                  StyledButton.strong(
                    labelText: 'Sign Up',
                    onPressed: () async {
                      final result = await loginPort.submit();
                      if (!result.isValid) {
                        return;
                      }

                      final data = result.data;

                      try {
                        final userId = await context.find<AuthCoreComponent>().signup(data['email'], data['password']);

                        await context.dropCoreComponent.updateEntity(
                          UserEntity()..id = userId,
                          (User user) => user..nameProperty.set('Jake'),
                        );

                        context.warpTo(HomePage());
                      } catch (e, stackTrace) {
                        final errorText = e.as<SignupFailure>()?.displayText ?? e.toString();
                        loginPort.setError(name: 'email', error: errorText);
                        context.logError(e, stackTrace);
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
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
    final loggedInUser = await context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId();
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

import 'dart:async';

import 'package:example/features/user/user.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LoginPage extends AppPage {
  late final redirectPathProperty = field<String>(name: 'redirect');

  @override
  Widget build(BuildContext context) {
    final loginPort = useMemoized(() => Port.of({
          'email': PortValue.string().isNotBlank().isEmail(),
          'password': PortValue.string().isNotBlank(),
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
              StyledList.row.centered.withScrollbar(children: [
                StyledButton(
                  labelText: 'Login',
                  onPressed: () async {
                    final result = await loginPort.submit();
                    if (!result.isValid) {
                      return;
                    }

                    final data = result.data;

                    try {
                      await context.run(
                        context.find<AuthCoreComponent>().loginAction,
                        LoginParameters(email: data['email'], password: data['password']),
                      );
                      context.warpTo(HomePage());
                    } catch (e, stackTrace) {
                      loginPort.setError(name: 'email', error: e.toString());
                      print(e);
                      print(stackTrace);
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
                      final userId = await context.run(
                        context.find<AuthCoreComponent>().signupAction,
                        SignupParameters(email: data['email'], password: data['password']),
                      );

                      final user = User()..nameProperty.set('Jake');
                      final userEntity = UserEntity()
                        ..id = userId
                        ..value = user;
                      await context.dropCoreComponent.update(userEntity);

                      context.warpTo(HomePage());
                    } catch (e, stackTrace) {
                      loginPort.setError(name: 'email', error: e.toString());
                      print(e);
                      print(stackTrace);
                    }
                  },
                ),
              ]),
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

import 'package:example/presentation/pages/auth/signup_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LoginPage with IsAppPageWrapper<LoginRoute> {
  @override
  AppPage<LoginRoute> get appPage => AppPage<LoginRoute>(
        builder: (context, route) {
          final loginPort = useMemoized(() => Port.of({
                'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
                'password': PortField.string().withDisplayName('Password').isNotBlank().isPassword(),
              }));

          return StyledPage(
            body: StyledList.column.centered.withScrollbar(
              children: [
                StyledImage.asset('assets/logo_foreground.png', width: 200, height: 200),
                StyledText.h1.strong('Welcome to Valet'),
                StyledDivider(),
                StyledObjectPortBuilder(port: loginPort),
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
                          context.warpTo(HomeRoute());
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
                        await context.push(SignupRoute()
                          ..initialEmailProperty.set(loginPort['email'])
                          ..initialPasswordProperty.set(loginPort['password']));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ).onlyIfNotLoggedIn();
}

class LoginRoute with IsRoute<LoginRoute> {
  late final redirectPathProperty = field<String>(name: 'redirect');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('login');

  @override
  List<RouteProperty> get queryProperties => [redirectPathProperty];

  @override
  LoginRoute copy() {
    return LoginRoute();
  }
}

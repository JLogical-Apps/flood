import 'package:example/presentation/pages/auth/signup_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/utils/otp_utils.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class LoginPage with IsAppPageWrapper<LoginRoute> {
  @override
  AppPage<LoginRoute> get appPage => AppPage<LoginRoute>().onlyIfNotLoggedIn();

  @override
  Widget onBuild(BuildContext context, LoginRoute route) {
    final loginPort = useMemoized(() => Port.of({
          'email': PortField.string().withDisplayName('Email').isNotBlank().isEmail(),
          'password': PortField.string().withDisplayName('Password').isNotBlank().isPassword(),
        }));
    final otpErrorState = useState<String?>(null);

    return StyledPage(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: StyledList.column.centered.withScrollbar(
            children: [
              StyledImage.asset('assets/logo_foreground.png', width: 200, height: 200),
              StyledText.twoXl.display.bold('Welcome to Flood'),
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
                        await context.authCoreComponent
                            .login(AuthCredentials.email(email: data['email'], password: data['password']));
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
              StyledButton.subtle(
                iconData: Icons.phone,
                labelText: 'Login with Phone',
                onPressed: () async {
                  try {
                    otpErrorState.value = null;
                    final account = await context.loginWithPhoneOtp();
                    if (account != null) {
                      context.warpTo(HomeRoute());
                    }
                  } catch (e, stackTrace) {
                    final errorText = e.as<LoginFailure>()?.displayText ?? e.toString();
                    otpErrorState.value = errorText;
                    context.logError(e, stackTrace);
                  }
                },
              ),
              if (otpErrorState.value != null) StyledText.body.error(otpErrorState.value!),
              StyledButton.subtle(
                labelText: 'Forgot Password?',
                onPressed: () {},
                isTextButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

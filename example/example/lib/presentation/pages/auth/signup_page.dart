import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flood/flood.dart';

class SignupRoute with IsRoute<SignupRoute> {
  late final redirectPathProperty = field<String>(name: 'redirect');
  late final initialEmailProperty = field<String>(name: 'email');
  late final initialPasswordProperty = field<String>(name: 'pass');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('signup');

  @override
  List<RouteProperty> get queryProperties => [redirectPathProperty];

  @override
  List<RouteProperty> get hiddenProperties => [
        initialEmailProperty,
        initialPasswordProperty,
      ];

  @override
  SignupRoute copy() {
    return SignupRoute();
  }
}

class SignupPage with IsAppPageWrapper<SignupRoute> {
  @override
  AppPage<SignupRoute> get appPage =>
      AppPage<SignupRoute>().onlyIfNotLoggedIn().withParent((context, route) => LoginRoute());

  @override
  Widget onBuild(BuildContext context, SignupRoute route) {
    final signupPort = useMemoized(() => Port.of({
          'name': PortField.string().withDisplayName('Name').isNotBlank().isName(),
          'email': PortField.string(initialValue: route.initialEmailProperty.value)
              .withDisplayName('Email')
              .isNotBlank()
              .isEmail(),
          'password': PortField.string(initialValue: route.initialPasswordProperty.value)
              .withDisplayName('Password')
              .isNotBlank()
              .isPassword(),
          'confirmPassword': PortField.string()
              .withDisplayName('Confirm Password')
              .isNotBlank()
              .isConfirmPassword(passwordField: 'password'),
        }));

    return StyledPage(
      titleText: 'Signup',
      body: StyledList.column.centered.withScrollbar(
        children: [
          StyledCard(
            titleText: 'Info',
            bodyText: 'Fill in your information to get started using Example!',
            leadingIcon: Icons.person,
            children: [
              StyledObjectPortBuilder(port: signupPort),
            ],
          ),
          StyledButton.strong(
            labelText: 'Sign Up',
            onPressed: () async {
              final result = await signupPort.submit();
              if (!result.isValid) {
                return;
              }

              final data = result.data;

              try {
                final account = await context
                    .find<AuthCoreComponent>()
                    .signup(AuthCredentials.email(email: data['email'], password: data['password']));
                final deviceToken = context.find<MessagingCoreComponent>().deviceToken;

                await context.dropCoreComponent.updateEntity(
                  UserEntity()..id = account.accountId,
                  (User user) => user
                    ..emailProperty.set(data['email'])
                    ..nameProperty.set(data['name'])
                    ..deviceTokenProperty.set(deviceToken),
                );

                await context.warpTo(HomeRoute());
              } catch (e, stackTrace) {
                final errorText = e.as<SignupFailure>()?.displayText ?? e.toString();
                signupPort.setError(path: 'email', error: errorText);
                context.logError(e, stackTrace);
              }
            },
          ),
        ],
      ),
    );
  }
}

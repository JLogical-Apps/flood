import 'dart:async';

import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/utils/budget_utils.dart';
import 'package:example_core/features/budget/budget.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SignupPage extends AppPage {
  late final redirectPathProperty = field<String>(name: 'redirect');
  late final initialEmailProperty = field<String>(name: 'email');
  late final initialPasswordProperty = field<String>(name: 'pass');

  @override
  Widget build(BuildContext context) {
    final signupPort = useMemoized(() => Port.of({
          'name': PortField.string().withDisplayName('Name').isNotBlank(),
          'email': PortField.string(initialValue: initialEmailProperty.value)
              .withDisplayName('Email')
              .isNotBlank()
              .isEmail(),
          'password': PortField.string(initialValue: initialPasswordProperty.value)
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
            bodyText: 'Fill in your information to get started using Valet!',
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
                final userId = await context.find<AuthCoreComponent>().signup(data['email'], data['password']);

                await context.dropCoreComponent.updateEntity(
                  UserEntity()..id = userId,
                  (User user) => user
                    ..emailProperty.set(data['email'])
                    ..nameProperty.set(data['name']),
                );

                final budgetEntity = await context.dropCoreComponent.updateEntity(
                  BudgetEntity(),
                  (Budget budget) => budget
                    ..nameProperty.set('Personal')
                    ..ownerProperty.set(userId),
                );

                await context.pushBudgetPage(budgetEntity.id!);
              } catch (e, stackTrace) {
                final errorText = e.as<SignupFailure>()?.displayText ?? e.toString();
                signupPort.setError(name: 'email', error: errorText);
                context.logError(e, stackTrace);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  AppPage copy() {
    return SignupPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('signup');

  @override
  List<RouteProperty> get queryProperties => [
        redirectPathProperty,
        initialEmailProperty,
        initialPasswordProperty,
      ];

  @override
  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) async {
    final loggedInUser = context.appPondContext.find<AuthCoreComponent>().loggedInUserId;
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

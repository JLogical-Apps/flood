import 'dart:async';

import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/settings/settings_entity.dart';
import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example/presentation/pages/budget/budgets_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('home');

  @override
  Widget build(BuildContext context) {
    return BudgetsPage();
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

    final settingsEntity = await SettingsEntity.getSettings(context.coreDropComponent);
    final budgetId = settingsEntity.value.budgetProperty.value;
    if (budgetId == null) {
      return null;
    }

    final budgetEntity = await Query.getByIdOrNull<BudgetEntity>(budgetId).get(context.coreDropComponent);
    if (budgetEntity == null) {
      return null;
    }

    return (BudgetPage()..budgetIdProperty.set(budgetId)).uri;
  }
}

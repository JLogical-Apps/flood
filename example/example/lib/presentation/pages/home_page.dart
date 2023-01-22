import 'dart:async';

import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('home');

  @override
  Widget build(BuildContext context) {
    final loggedInUserIdModel =
        useFutureModel(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId());
    final budgetsModel = useQueryModel(useMemoized(() => loggedInUserIdModel.map((loggedInUserId) =>
        Query.from<BudgetEntity>().where(Budget.ownerField).isEqualTo(loggedInUserId).all<BudgetEntity>())));
    return StyledPage(
      titleText: 'Home',
      body: Center(
        child: Column(
          children: [
            ModelBuilder<String?>(
              model: loggedInUserIdModel,
              builder: (userId) {
                return StyledText.h1('Welcome ${userId!.substring(0, 2)}!');
              },
            ),
            ModelBuilder<List<BudgetEntity>>(
              model: budgetsModel,
              builder: (budgetEntities) {
                return Column(children: [
                  ...budgetEntities.map((entity) => StyledText.h2(entity.value.nameProperty.value)),
                  StyledButton.strong(
                    labelText: 'Create +',
                    onPressed: () async {
                      final newBudgetEntity = BudgetEntity()
                        ..value = (Budget()
                          ..nameProperty.set(DateTime.now().second.toString())
                          ..ownerProperty.set(loggedInUserIdModel.getOrNull()!));
                      await context.dropCoreComponent.update(newBudgetEntity);
                    },
                  ),
                ]);
              },
            ),
          ],
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

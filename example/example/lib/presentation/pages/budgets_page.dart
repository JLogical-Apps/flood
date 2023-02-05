import 'dart:async';

import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:example/presentation/pages/budget_page.dart';
import 'package:example/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetsPage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('budgets');

  @override
  Widget build(BuildContext context) {
    final loggedInUserIdModel =
        useFutureModel(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId());
    final loggedInUserModel = useNullableQueryModel(useMemoized(() => loggedInUserIdModel.map((loggedInUserId) =>
        loggedInUserId?.mapIfNonNull((loggedInUserId) => Query.getByIdOrNull<UserEntity>(loggedInUserId)))));
    final budgetsModel = useQueryModel(useMemoized(() => loggedInUserIdModel.map((loggedInUserId) =>
        Query.from<BudgetEntity>().where(Budget.ownerField).isEqualTo(loggedInUserId).all<BudgetEntity>())));
    return StyledPage(
      titleText: 'Home',
      body: Center(
        child: Column(
          children: [
            ModelBuilder<UserEntity?>(
              model: loggedInUserModel,
              builder: (userEntity) {
                return StyledText.h1('Welcome ${userEntity?.value.nameProperty.value ?? 'N/A'}');
              },
            ),
            ModelBuilder<List<BudgetEntity>>(
              model: budgetsModel,
              builder: (budgetEntities) {
                return StyledList.column.scrollable(
                  children: [
                    StyledList.column.withMinChildSize(150)(
                      children: budgetEntities
                          .map((budgetEntity) => StyledCard(
                                titleText: budgetEntity.value.nameProperty.value,
                                bodyText: 'Budget',
                                onPressed: () {
                                  context.warpTo(BudgetPage()..budgetIdProperty.set(budgetEntity.id!));
                                },
                              ))
                          .toList(),
                    ),
                    StyledButton.strong(
                      labelText: 'Create +',
                      onPressed: () async {
                        final result = await context.style().showDialog(
                            context,
                            StyledPortDialog(
                              titleText: 'Create New Budget',
                              port: Port.of({
                                'name': PortValue.string().isNotBlank(),
                              }),
                              children: [
                                StyledTextFieldPortField(
                                  fieldName: 'name',
                                  labelText: 'Name',
                                ),
                              ],
                            ));
                        if (result == null) {
                          return;
                        }

                        final newBudgetEntity = BudgetEntity()
                          ..value = (Budget()
                            ..nameProperty.set(result['name'])
                            ..ownerProperty.set(loggedInUserIdModel.getOrNull()!));
                        await context.dropCoreComponent.update(newBudgetEntity);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  AppPage copy() {
    return BudgetsPage();
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

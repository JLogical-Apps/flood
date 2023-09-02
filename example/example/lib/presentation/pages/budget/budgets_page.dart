import 'dart:async';

import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example_core/example_core.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetsPage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('budgets');

  @override
  Widget build(BuildContext context) {
    final loggedInUserId = useLoggedInUserId()!;
    final loggedInUserModel = useEntityOrNull<UserEntity>(loggedInUserId);
    final budgetsModel = useQuery(Query.from<BudgetEntity>().where(Budget.ownerField).isEqualTo(loggedInUserId).all());
    return StyledPage(
      titleText: 'Home',
      body: StyledList.column.scrollable.withScrollbar(
        children: [
          ModelBuilder<UserEntity?>(
            model: loggedInUserModel,
            builder: (userEntity) {
              return StyledText.h1('Welcome ${userEntity?.value.nameProperty.value ?? 'N/A'}');
            },
          ),
          ModelBuilder(
            model: budgetsModel,
            builder: (List<BudgetEntity> budgetEntities) {
              return StyledList.column(
                children: [
                  StyledList.column.withMinChildSize(150)(
                    children: budgetEntities
                        .map((budgetEntity) => StyledCard(
                              titleText: budgetEntity.value.nameProperty.value,
                              onPressed: () async {
                                await context.dropCoreComponent.updateEntity(
                                  await SettingsEntity.getSettings(context.dropCoreComponent),
                                  (Settings settings) => settings.budgetProperty.set(budgetEntity.id!),
                                );

                                context.warpTo(BudgetPage()..budgetIdProperty.set(budgetEntity.id!));
                              },
                            ))
                        .toList(),
                    ifEmptyText: 'You have no budgets! Click the Create button below to create your first one.',
                  ),
                  StyledButton.strong(
                    labelText: 'Create',
                    iconData: Icons.add,
                    onPressed: () async {
                      await context.showStyledDialog(StyledPortDialog(
                        titleText: 'Create New Budget',
                        port: (Budget()..ownerProperty.set(loggedInUserId)).asPort(context.corePondContext),
                        onAccept: (Budget result) async {
                          await context.dropCoreComponent.update(BudgetEntity()..value = result);
                        },
                      ));
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  AppPage copy() {
    return BudgetsPage();
  }

  @override
  FutureOr<Uri?> redirectTo(BuildContext context, Uri currentUri) async {
    final loggedInUser = context.appPondContext.find<AuthCoreComponent>().loggedInUserId;
    if (loggedInUser == null) {
      final loginPage = LoginPage()..redirectPathProperty.set(currentUri.toString());
      return loginPage.uri;
    }

    return null;
  }
}

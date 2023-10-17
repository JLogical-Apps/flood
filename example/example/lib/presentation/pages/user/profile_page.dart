import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/utils/budget_utils.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example/presentation/widget/budget/budget_card.dart';
import 'package:example_core/features/budget/budget.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ProfileRoute with IsRoute<ProfileRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('profile');

  @override
  ProfileRoute copy() {
    return ProfileRoute();
  }
}

class ProfilePage with IsAppPageWrapper<ProfileRoute> {
  @override
  AppPage<ProfileRoute> get appPage => AppPage<ProfileRoute>().onlyIfLoggedIn();

  @override
  Widget onBuild(BuildContext context, ProfileRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    final loggedInUserModel = useEntityOrNull<UserEntity>(loggedInUserId);
    final budgetsModel = useQueryOrNull(
        loggedInUserId?.mapIfNonNull((value) => BudgetEntity.getBudgetsQuery(userId: loggedInUserId).all()));
    return ModelBuilder.page(
        model: loggedInUserModel,
        builder: (UserEntity? userEntity) {
          if (loggedInUserId == null || userEntity == null) {
            return StyledLoadingPage();
          }

          return StyledPage(
            titleText: 'Profile',
            actions: [
              ActionItem(
                titleText: 'Logout',
                descriptionText: 'Log out of your account.',
                iconData: Icons.logout,
                color: Colors.red,
                onPerform: (context) async {
                  await context.find<AuthCoreComponent>().logout();
                  await context.warpTo(LoginRoute());
                },
              ),
            ],
            body: StyledList.column.scrollable.centered.withScrollbar(
              children: [
                StyledCard(
                  titleText: 'Welcome ${userEntity.value.nameProperty.value}',
                  leadingIcon: Icons.person,
                  actions: [
                    ActionItem(
                      titleText: 'Edit',
                      descriptionText: 'Edit your details.',
                      iconData: Icons.edit,
                      color: Colors.orange,
                      onPerform: (context) async {
                        await context.showStyledDialog(StyledPortDialog(
                          titleText: 'Edit Details',
                          port: userEntity.value.asPort(context.corePondContext),
                          onAccept: (User user) {
                            context.dropCoreComponent.updateEntity(userEntity..set(user));
                          },
                        ));
                      },
                    ),
                  ],
                  children: [
                    StyledReadonlyTextField(
                      labelText: 'Email',
                      leadingIcon: Icons.email,
                      text: userEntity.value.emailProperty.value,
                    ),
                  ],
                ),
                ModelBuilder(
                    model: budgetsModel,
                    builder: (List<BudgetEntity>? budgetEntities) {
                      if (budgetEntities == null) {
                        return StyledLoadingIndicator();
                      }
                      return StyledCard(
                        titleText: 'Budgets',
                        leadingIcon: Icons.folder,
                        actions: [
                          ActionItem(
                            titleText: 'Create Budget',
                            descriptionText: 'Create a new budget.',
                            color: Colors.green,
                            iconData: Icons.create_new_folder,
                            onPerform: (context) async {
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
                        children: [
                          StyledList.column.withMinChildSize(150)(
                            children: budgetEntities
                                .map((budgetEntity) => BudgetEntityCard(
                                      budgetId: budgetEntity.id!,
                                      onPressed: () async {
                                        await context.pushBudgetRoute(budgetEntity.id!);
                                      },
                                    ))
                                .toList(),
                            ifEmptyText: 'You have no budgets! Click the Create button below to create your first one.',
                          ),
                        ],
                      );
                    }),
              ],
            ),
          );
        });
  }
}
import 'package:example/pond/domain/budget/budget.dart';
import 'package:example/pond/domain/budget/budget_draft_entity.dart';
import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:example/pond/presentation/budget_created_analytic.dart';
import 'package:example/pond/presentation/pond_budget_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../domain/budget/budget_draft.dart';
import 'pond_login_page.dart';

class PondHomePage extends HookWidget {
  final String userId;

  const PondHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorModel = useMemoized(() => Model(loader: () => throw Exception('hA!')));
    final userEntityController = useEntity<UserEntity>(userId);
    final userBudgetsController = useQuery(
      Query.from<BudgetEntity>()
          .where(Budget.ownerField, isEqualTo: userId)
          .orderByDescending(ValueObject.timeCreatedField)
          .paginate(),
    );
    return Banner(
      message: AppContext.global.environment.name.toUpperCase(),
      location: BannerLocation.topEnd,
      textDirection: TextDirection.ltr,
      layoutDirection: TextDirection.ltr,
      color: Colors.red,
      child: StyleProvider(
        style: PondLoginPage.style,
        child: Builder(builder: (context) {
          return ModelBuilder.styledPage(
            model: userEntityController.model,
            builder: (UserEntity userEntity) {
              return StyledPage(
                onRefresh: () => Future.wait([userEntityController.reload(), userBudgetsController.reload()]),
                titleText: 'Home: ${userEntity.value.nameProperty.value}',
                actions: [
                  ActionItem(
                    name: 'Log Out',
                    onPerform: () async {
                      await locate<AuthService>().logout();
                      context.style().navigateReplacement(context: context, newPage: (_) => PondLoginPage());
                    },
                  ),
                ],
                body: ModelBuilder.styled(
                  model: userBudgetsController.model,
                  builder: (QueryPaginationResultController<BudgetEntity> budgetsController) {
                    return HookBuilder(builder: (context) {
                      final results = useValueStream(budgetsController.resultsX);
                      return Column(
                        children: [
                          ModelBuilder.styled(model: errorModel, builder: (_) => StyledBodyText('Huh?')),
                          StyledCategory.medium(
                            headerText: 'Budgets',
                            actions: [
                              ActionItem(
                                name: 'Create',
                                description: 'Create a budget for this user.',
                                color: Colors.green,
                                leading: Icon(Icons.monetization_on),
                                onPerform: () async {
                                  final draftEntity = await Singleton.getOrCreate<BudgetDraftEntity, BudgetDraft>();
                                  final budgetDraft = draftEntity.value.sourcePrototype;

                                  final data = await StyledDialog.smartForm(
                                    context: context,
                                    onFormChange: (controller) async {
                                      final budget = Budget()..nameProperty.setUnvalidated(controller.getData('name'));
                                      final budgetDraft = BudgetDraft()..sourcePrototype = budget;
                                      draftEntity..value = budgetDraft;
                                      await draftEntity.createOrSave();
                                    },
                                    children: [
                                      StyledSmartTextField(
                                        name: 'name',
                                        label: 'Name',
                                        initialValue: budgetDraft.nameProperty.getUnvalidated(),
                                        validators: [Validation.required()],
                                      ),
                                    ],
                                  ).show(context);

                                  if (data == null) {
                                    return;
                                  }

                                  await draftEntity.delete();

                                  final budget = Budget()
                                    ..nameProperty.value = data['name']
                                    ..ownerProperty.value = userId;

                                  final budgetEntity = BudgetEntity()..value = budget;

                                  await budgetEntity.create();
                                  await BudgetCreatedAnalytic().log();
                                },
                              ),
                            ],
                            noChildrenWidget: StyledContentSubtitleText('No budgets'),
                            children: [
                              ...results.map((budget) => BudgetCard(
                                    budgetId: budget.id!,
                                    key: ValueKey(budget.id),
                                  )),
                              if (budgetsController.canLoadMore)
                                StyledButton.low(
                                  text: 'Load More',
                                  onTapped: () async {
                                    await budgetsController.loadMore();
                                  },
                                ),
                            ],
                          ),
                        ],
                      );
                    });
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class BudgetCard extends HookWidget {
  final String budgetId;

  const BudgetCard({Key? key, required this.budgetId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetEntityController = useEntity<BudgetEntity>(budgetId);

    return ModelBuilder.styled(
      model: budgetEntityController.model,
      builder: (BudgetEntity budgetEntity) {
        final budget = budgetEntity.value;
        return StyledContent(
          headerText: budget.nameProperty.value,
          onTapped: () {
            context.style().navigateTo(context: context, page: (context) => PondBudgetPage(budgetId: budgetEntity.id!));
          },
          actions: [
            ActionItem(
              name: 'Delete',
              description: 'Delete this budget.',
              color: Colors.red,
              leading: Icon(Icons.delete),
              onPerform: () async {
                final dialog = StyledDialog.yesNo(
                  context: context,
                  titleText: 'Confirm Delete',
                  children: [
                    StyledBodyText('Are you sure you want to delete this budget?'),
                  ],
                );
                if (await dialog.show(context) == true) {
                  await budgetEntity.delete();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

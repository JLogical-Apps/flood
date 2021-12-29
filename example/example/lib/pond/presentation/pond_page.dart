import 'dart:io';

import 'package:example/pond/domain/budget/budget.dart';
import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/budget/budget_repository.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_repository.dart';
import 'package:example/pond/domain/envelope/envelope_repository.dart';
import 'package:example/pond/domain/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondPage extends HookWidget {
  final Directory baseBudgetDirectory;

  const PondPage({Key? key, required this.baseBudgetDirectory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useOneTimeEffect(() {
      _initPond();
    });
    final budgetsQuery = useQuery(Query.from<BudgetEntity>().paginate(limit: 3));
    return StyleProvider(
        style: DeltaStyle(backgroundColor: Color(0xff030818)),
        child: Builder(
          builder: (context) => ModelBuilder.styledPage(
            model: budgetsQuery.model,
            builder: (QueryPaginationResultController<BudgetEntity> budgetResultController) {
              final results = useValueStream(budgetResultController.resultsX);
              return StyledPage(
                onRefresh: budgetsQuery.reload,
                titleText: 'Home',
                body: StyledCategory.medium(
                  headerText: 'Budgets',
                  children: [
                    StyledButton.high(
                      text: 'Create',
                      onTapped: () {
                        final budgetEntity = BudgetEntity(initialValue: Budget()..nameProperty.value = 'New Budget');
                        budgetEntity.create();
                      },
                    ),
                    ...results.map((budgetEntity) => BudgetCard(budgetId: budgetEntity.id!)),
                    if (budgetResultController.canLoadMore)
                      StyledButton.low(
                        text: 'Load More',
                        onTapped: () async {
                          await budgetResultController.loadMore();
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  void _initPond() {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(
        repositories: [
          FileBudgetRepository(baseDirectory: baseBudgetDirectory),
          LocalBudgetTransactionRepository(),
          LocalEnvelopeRepository(),
          LocalUserRepository(),
        ],
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
          bodyText: budget.ownerProperty.reference?.value.nameProperty.value,
          actions: [
            ActionItem(
              name: 'Edit',
              onPerform: () async {
                final edit = await StyledDialog.smartForm(context: context, titleText: 'Edit', children: [
                  StyledSmartTextField(
                    name: 'name',
                    label: 'Name',
                    suggestedValue: budget.nameProperty.value,
                  ),
                ]).show(context);
                if (edit == null) {
                  return;
                }

                budget.nameProperty.value = edit['name'];
                budgetEntity.save();
              },
            ),
            ActionItem(name: 'Delete', onPerform: () => budgetEntity.delete()),
          ],
        );
      },
    );
  }
}

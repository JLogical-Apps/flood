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
  const PondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useOneTimeEffect(() {
      _initPond();
    });
    final budgetsQuery = useQuery(Query.from<BudgetEntity>().all());
    return StyleProvider(
        style: DeltaStyle(backgroundColor: Color(0xff030818)),
        child: Builder(
          builder: (context) => ModelBuilder.styledPage(
            model: budgetsQuery.model,
            builder: (List<BudgetEntity> budgets) => StyledPage(
              onRefresh: budgetsQuery.reload,
              titleText: 'Home',
              body: StyledCategory.medium(
                headerText: 'Budgets',
                children: [
                  ...budgets.map((budgetEntity) => BudgetCard(budgetId: budgetEntity.id!)),
                  StyledButton.high(
                    text: 'Create',
                    onTapped: () {
                      final budgetEntity = BudgetEntity(initialValue: Budget()..nameProperty.value = 'A');
                      budgetEntity.create();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _initPond() {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(
        repositories: [
          LocalBudgetRepository(),
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

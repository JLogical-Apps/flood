import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/pages/transaction/add_transactions_page.dart';
import 'package:example/presentation/widget/envelope/envelope_card.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetPage extends AppPage {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('budget').property(budgetIdProperty);

  @override
  Widget build(BuildContext context) {
    final budgetModel = useQuery(Query.getByIdOrNull<BudgetEntity>(budgetIdProperty.value));
    final envelopesModel =
        useQuery(EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: budgetIdProperty.value, isArchived: false).all());

    final transactionsModel =
        useQuery(BudgetTransactionEntity.getBudgetTransactionsQuery(budgetId: budgetIdProperty.value).paginate());

    final totalCentsModel = useMemoized(() => envelopesModel
        .map((envelopeEntities) => envelopeEntities.sumByInt((entity) => entity.value.amountCentsProperty.value)));

    return ModelBuilder.page(
      model: budgetModel,
      builder: (BudgetEntity? budgetEntity) {
        if (budgetEntity == null) {
          return StyledLoadingPage();
        }

        final budget = budgetEntity.value;
        return StyledPage(
          titleText: '${budget.nameProperty.value}: ${totalCentsModel.getOrNull()?.formatCentsAsCurrency() ?? '...'}',
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit the budget.',
              iconData: Icons.edit,
              color: Colors.orange,
              onPerform: (context) async {
                final result = await context.showStyledDialog(StyledPortDialog(
                  titleText: 'Edit Budget',
                  port: budget.asPort(context.corePondContext),
                ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(budgetEntity..value = result);
              },
            ),
            ActionItem(
              titleText: 'Delete',
              descriptionText: 'Delete the budget.',
              iconData: Icons.delete,
              color: Colors.red,
              onPerform: (context) async {
                final result = await context.showStyledDialog(StyledDialog.yesNo(
                  titleText: 'Confirm Delete Budget',
                  bodyText: 'Are you sure you want to delete the budget? You cannot undo this.',
                ));
                if (result != true) {
                  return;
                }

                await context.dropCoreComponent.delete(budgetEntity);
                context.pop();
              },
            ),
          ],
          body: StyledList.column.scrollable(
            children: [
              StyledButton.strong(
                labelText: 'Add Transactions',
                iconData: Icons.attach_money,
                onPressed: () async {
                  await context.push(AddTransactionsPage()..budgetIdProperty.set(budgetIdProperty.value));
                },
              ),
              StyledCard(
                titleText: 'Envelopes',
                leadingIcon: Icons.mail,
                actions: [
                  ActionItem(
                    titleText: 'Create',
                    descriptionText: 'Create a new envelope.',
                    iconData: Icons.add,
                    color: Colors.green,
                    onPerform: (_) async {
                      final result = await context.showStyledDialog(StyledPortDialog(
                        titleText: 'Create New Envelope',
                        port: (Envelope()..budgetProperty.set(budgetEntity.id!)).asPort(context.corePondContext),
                      ));
                      if (result == null) {
                        return;
                      }

                      await context.dropCoreComponent.update(EnvelopeEntity()..value = result);
                    },
                  ),
                ],
                children: [
                  ModelBuilder(
                    model: envelopesModel,
                    builder: (List<EnvelopeEntity> envelopeEntities) {
                      return StyledList.column.withMinChildSize(150)(
                        children: [
                          ...envelopeEntities.map((envelopeEntity) {
                            return EnvelopeCard(
                              envelope: envelopeEntity.value,
                              onPressed: () async {
                                context.push(EnvelopePage()..idProperty.set(envelopeEntity.id!));
                              },
                            );
                          }).toList(),
                        ],
                        ifEmptyText:
                            'There are no envelopes in this budget! Create one by pressing the triple-dot menu above!',
                      );
                    },
                  ),
                ],
              ),
              StyledCard(
                titleText: 'Transactions',
                leadingIcon: Icons.swap_horiz,
                children: [
                  PaginatedQueryModelBuilder(
                    paginatedQueryModel: transactionsModel,
                    builder: (List<BudgetTransactionEntity> transactionEntities, loadMore) {
                      return StyledList.column(
                        ifEmptyText: 'There are no transactions in this budget!',
                        children: [
                          ...transactionEntities
                              .map((entity) => TransactionCard(
                                    budgetTransaction: entity.value,
                                    id: entity.id,
                                    transactionViewContext: TransactionViewContext.budget(),
                                  ))
                              .toList(),
                          if (loadMore != null)
                            StyledButton.strong(
                              labelText: 'Load More',
                              onPressed: loadMore,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  AppPage copy() {
    return BudgetPage();
  }

  @override
  AppPage? getParent() {
    return HomePage();
  }
}

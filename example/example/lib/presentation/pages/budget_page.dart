import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/presentation/pages/add_income_page.dart';
import 'package:example/presentation/pages/envelope_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetPage extends AppPage {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  Widget build(BuildContext context) {
    final budgetModel = useQuery(Query.getByIdOrNull<BudgetEntity>(budgetIdProperty.value));
    final envelopesModel =
        useQuery(Query.from<EnvelopeEntity>().where(Envelope.budgetField).isEqualTo(budgetIdProperty.value).all());

    final transactionsModel = useQuery(Query.from<BudgetTransactionEntity>()
        .where(BudgetTransaction.budgetField)
        .isEqualTo(budgetIdProperty.value)
        .paginate());

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
          titleText: budget.nameProperty.value,
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
                  children: [
                    StyledTextFieldPortField(
                      fieldName: Budget.nameField,
                      labelText: 'Name',
                    ),
                  ],
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
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.delete(budgetEntity);
                context.pop();
              },
            ),
          ],
          body: StyledList.column.scrollable(
            children: [
              ModelBuilder(
                model: totalCentsModel,
                builder: (int cents) {
                  return StyledList.row.centered(children: [
                    StyledText.h3('Total:'),
                    StyledText.h3.strong(cents.formatCentsAsCurrency()),
                  ]);
                },
              ),
              StyledButton.strong(
                labelText: 'Add Income',
                onPressed: () async {
                  await context.push(AddIncomePage());
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
                    onPerform: (context) async {
                      final result = await context.showStyledDialog(StyledPortDialog(
                        titleText: 'Create New Envelope',
                        port: (Envelope()..budgetProperty.set(budgetEntity.id)).asPort(context.corePondContext),
                        children: [
                          StyledTextFieldPortField(
                            fieldName: Envelope.nameField,
                            labelText: 'Name',
                          ),
                        ],
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
                          ...envelopeEntities
                              .map((envelopeEntity) => StyledCard(
                                    titleText: envelopeEntity.value.nameProperty.value,
                                    bodyText: envelopeEntity.value.amountCentsProperty.value.formatCentsAsCurrency(),
                                    onPressed: () async {
                                      context.push(EnvelopePage()..idProperty.set(envelopeEntity.id!));
                                    },
                                  ))
                              .toList(),
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
                        children: [
                          ...transactionEntities
                              .map((entity) => StyledCard(titleText: entity.value.affectedEnvelopesProperty.name))
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
  PathDefinition get pathDefinition => PathDefinition.string('budget').property(budgetIdProperty);

  @override
  AppPage? getParent() {
    return HomePage();
  }
}

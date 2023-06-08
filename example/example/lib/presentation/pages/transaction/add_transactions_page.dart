import 'dart:async';

import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/transfer_transaction_edit_dialog.dart';
import 'package:example/presentation/pages/transaction/transaction_generator.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class AddTransactionsPage extends AppPage<AddTransactionsPage> {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('addTransactions').property(budgetIdProperty);

  @override
  Widget build(BuildContext context) {
    final budgetModel = useQuery(Query.getByIdOrNull<BudgetEntity>(budgetIdProperty.value));
    final budget = budgetModel.getOrNull()?.value;

    final envelopesModel =
        useQuery(EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: budgetIdProperty.value, isArchived: false).all());
    final envelopeEntities = envelopesModel.getOrNull();
    if (envelopeEntities == null) {
      return StyledLoadingPage();
    }

    final envelopeById = envelopeEntities.mapToMap((entity) => MapEntry(entity.id!, entity.value));

    final transactionGeneratorsState = useState<List<TransactionGenerator>>([]);
    final transactions = transactionGeneratorsState.value
        .map((transactionGenerator) => transactionGenerator.generate(envelopeById))
        .toList();
    final modifiedEnvelopeById = budget
        ?.addTransactions(
          context.coreDropComponent,
          envelopeById: envelopeEntities.mapToMap((entity) => MapEntry(entity.id!, entity.value)),
          transactions: transactions,
        )
        .modifiedEnvelopeById;

    return StyledPage(
      titleText: 'Add Transactions',
      body: StyledList.column.scrollable.withScrollbar.centered(
        children: [
          StyledButton.strong(
            labelText: 'Add Income',
            iconData: Icons.attach_money,
            onPressed: () async {
              final budgetEntity = (await budgetModel.getOrLoad()) ??
                  (throw Exception('Cannot load budget! [${budgetIdProperty.value}]'));

              final transactionGenerator = await context.showStyledDialog(StyledPortDialog(
                  titleText: 'Add Income',
                  port: Port.of(
                    {
                      'incomeCents':
                          PortField<int?, int>(value: null).withDisplayName('Income (\$)').currency().isNotNull(),
                      'transactionDate': PortField.dateTime(isTime: false, initialValue: DateTime.now())
                          .withDisplayName('Income Date')
                          .isNotNull(),
                    },
                  ).map((resultByName, port) => IncomeTransactionGenerator(
                        incomeCents: resultByName['incomeCents'] as int,
                        transactionDate: resultByName['transactionDate'] as DateTime,
                        budgetId: budgetIdProperty.value,
                        budget: budgetEntity.value,
                        coreDropContext: context.coreDropComponent,
                      ))));

              if (transactionGenerator == null) {
                return;
              }

              transactionGeneratorsState.value = _getSortedTransactionGenerators(
                existingGenerators: transactionGeneratorsState.value + [transactionGenerator],
                envelopeById: envelopeById,
              );
            },
          ),
          StyledCard(
            titleText: 'Envelopes',
            bodyText: 'Add a transaction to an envelope by tapping it.',
            leadingIcon: Icons.mail,
            children: [
              ModelBuilder(
                model: envelopesModel,
                builder: (List<EnvelopeEntity> envelopeEntities) {
                  return StyledList.column.withMinChildSize(200).centered(
                        children: envelopeEntities
                            .map((entity) => _buildEnvelopeSelectCard(
                                  context,
                                  envelopeEntity: entity,
                                  modifiedEnvelopeById: modifiedEnvelopeById,
                                  onTransactionCreated: (envelopeTransaction) =>
                                      transactionGeneratorsState.value = _getSortedTransactionGenerators(
                                    existingGenerators: transactionGeneratorsState.value +
                                        [
                                          WrapperTransactionGenerator(transaction: envelopeTransaction),
                                        ],
                                    envelopeById: envelopeById,
                                  ),
                                ))
                            .toList(),
                        ifEmptyText: 'You have no envelopes!',
                      );
                },
              ),
            ],
          ),
          StyledCard(
            titleText: 'Transactions',
            bodyText: 'View the transactions in this batch.',
            leadingIcon: Icons.mail,
            children: [
              StyledList.column(
                children: transactionGeneratorsState.value
                    .map((transactionGenerator) => TransactionCard(
                          budgetTransaction: transactionGenerator.generate(envelopeById),
                          transactionViewContext: TransactionViewContext.budget(),
                          actions: [
                            ActionItem(
                              titleText: 'Remove',
                              descriptionText: 'Remove this transaction.',
                              color: Colors.red,
                              iconData: Icons.remove_circle_outline,
                              onPerform: (_) async {
                                transactionGeneratorsState.value = transactionGeneratorsState.value.copy()
                                  ..remove(transactionGenerator);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ))
                    .toList(),
                ifEmptyText: 'No Transactions yet!',
              ),
            ],
          ),
          StyledButton.strong(
            labelText: 'Save',
            iconData: Icons.save,
            onPressed: transactions.isEmpty
                ? null
                : () async {
                    if (modifiedEnvelopeById == null) {
                      return;
                    }

                    for (final transaction in transactions) {
                      final budgetTransactionEntity =
                          BudgetTransactionEntity.constructEntityFromTransactionTypeRuntime(transaction.runtimeType)
                            ..set(transaction);
                      await context.coreDropComponent.update(budgetTransactionEntity);
                    }
                    for (final entry in modifiedEnvelopeById.entries) {
                      await context.coreDropComponent.updateEntity(
                        envelopeEntities.firstWhere((entity) => entity.id == entry.key)..set(entry.value),
                      );
                    }
                    context.pop();
                  },
          ),
        ],
      ),
    );
  }

  List<TransactionGenerator> _getSortedTransactionGenerators({
    required List<TransactionGenerator> existingGenerators,
    required Map<String, Envelope> envelopeById,
  }) {
    existingGenerators.sort(
      (a, b) => a
          .generate(envelopeById)
          .transactionDateProperty
          .value
          .compareTo(b.generate(envelopeById).transactionDateProperty.value),
    );
    return existingGenerators;
  }

  StyledCard _buildEnvelopeSelectCard(
    BuildContext context, {
    required EnvelopeEntity envelopeEntity,
    required Map<String, Envelope>? modifiedEnvelopeById,
    required FutureOr Function(BudgetTransaction) onTransactionCreated,
  }) {
    final envelope = envelopeEntity.value;
    final envelopeCardModification = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);

    final newEnvelope = modifiedEnvelopeById?[envelopeEntity.id];
    final centDifference =
        newEnvelope == null ? 0 : newEnvelope.amountCentsProperty.value - envelope.amountCentsProperty.value;

    return StyledCard(
      title: StyledText.h6.withColor(Color(envelope.colorProperty.value))(envelope.nameProperty.value),
      leading:
          envelopeCardModification.getIcon(envelope.ruleProperty.value, color: Color(envelope.colorProperty.value)),
      actions: [
        ActionItem(
          titleText: 'Edit',
          descriptionText: 'Edit the envelope.',
          iconData: Icons.edit,
          color: Colors.orange,
          onPerform: (context) async {
            await context.showStyledDialog(StyledPortDialog(
              titleText: 'Edit Envelope',
              port: envelope.asPort(context.corePondContext),
              onAccept: (Envelope result) async {
                await context.coreDropComponent.update(envelopeEntity..value = result);
              },
            ));
          },
        ),
        ActionItem(
          titleText: 'Transfer',
          descriptionText: 'Transfer money to/from this envelope.',
          color: Colors.blue,
          iconData: Icons.swap_horiz,
          onPerform: (context) async {
            await context.showStyledDialog(await TransferTransactionEditDialog.create(
              context,
              titleText: 'Create Transfer',
              sourceEnvelopeEntity: envelopeEntity,
              transferTransaction: TransferTransaction()..budgetProperty.set(envelope.budgetProperty.value),
              onAccept: (TransferTransaction result) async {
                await onTransactionCreated(result);
              },
            ));
          },
        ),
      ],
      onPressed: () async {
        await context.showStyledDialog(EnvelopeTransactionEditDialog(
          corePondContext: context.corePondContext,
          titleText: 'Create Transaction',
          envelopeTransaction: EnvelopeTransaction()
            ..envelopeProperty.set(envelopeEntity.id!)
            ..budgetProperty.set(envelope.budgetProperty.value),
          onAccept: (EnvelopeTransaction envelopeTransaction) async {
            await onTransactionCreated(envelopeTransaction);
          },
        ));
      },
      body: StyledList.row.scrollable.withScrollbar(
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        children: [
          StyledText.body(envelope.amountCentsProperty.value.formatCentsAsCurrency()),
          StyledText.body('+'),
          StyledText.body.withColor(getCentsColor(centDifference))(centDifference.formatCentsAsCurrency()),
          StyledIcon(Icons.arrow_right),
          if (modifiedEnvelopeById == null) StyledLoadingIndicator(),
          StyledText.body.withColor(getCentsColor(newEnvelope?.amountCentsProperty.value))(
              (newEnvelope ?? envelope).amountCentsProperty.value.formatCentsAsCurrency()),
        ],
      ),
    );
  }

  @override
  AddTransactionsPage copy() {
    return AddTransactionsPage();
  }
}

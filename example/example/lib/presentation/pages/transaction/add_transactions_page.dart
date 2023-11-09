import 'dart:async';

import 'package:collection/collection.dart';
import 'package:example/presentation/dialog/envelope/envelope_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/transfer_transaction_edit_dialog.dart';
import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example/presentation/pages/transaction/transaction_generator.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example/presentation/widget/util/percent_indicator.dart';
import 'package:example_core/features/budget/budget.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/budget_transaction.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class AddTransactionsRoute with IsRoute<AddTransactionsRoute> {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('addTransactions').property(budgetIdProperty);

  @override
  AddTransactionsRoute copy() {
    return AddTransactionsRoute();
  }
}

class AddTransactionsPage with IsAppPageWrapper<AddTransactionsRoute> {
  @override
  AppPage<AddTransactionsRoute> get appPage => AppPage<AddTransactionsRoute>()
      .onlyIfLoggedIn()
      .withParent((context, route) => BudgetRoute()..budgetIdProperty.set(route.budgetIdProperty.value));

  (List<BudgetTransaction>, Map<String, Envelope>) _applyTransactionGenerators({
    required DropCoreContext dropCoreContext,
    required Map<String, Envelope> envelopeById,
    required List<TransactionGenerator> transactionGenerators,
  }) {
    final transactions = <BudgetTransaction>[];
    for (final transactionGenerator in transactionGenerators) {
      final newTransaction = transactionGenerator.generate(envelopeById);
      transactions.add(newTransaction);
      envelopeById = Budget.addTransactions(dropCoreContext, envelopeById: envelopeById, transactions: [newTransaction])
          .modifiedEnvelopeById;
    }

    return (transactions, envelopeById);
  }

  @override
  Widget onBuild(BuildContext context, AddTransactionsRoute route) {
    final envelopesModel = useQuery(
        EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: route.budgetIdProperty.value, isArchived: false).all());

    final transactionGeneratorsState = useState<List<TransactionGenerator>>([]);

    return ModelBuilder.page(
        model: envelopesModel,
        builder: (List<EnvelopeEntity> envelopeEntities) {
          final envelopeById = envelopeEntities.mapToMap((entity) => MapEntry(entity.id!, entity.value));

          final (transactions, modifiedEnvelopeById) = _applyTransactionGenerators(
            dropCoreContext: context.dropCoreComponent,
            envelopeById: envelopeById,
            transactionGenerators: transactionGeneratorsState.value,
          );

          return StyledPage(
            titleText: 'Add Transactions',
            body: StyledList.column.scrollable.withScrollbar.centered(
              children: [
                StyledButton.strong(
                  labelText: 'Add Income',
                  iconData: Icons.attach_money,
                  onPressed: () async {
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
                              budgetId: route.budgetIdProperty.value,
                              dropCoreContext: context.dropCoreComponent,
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
                StyledCard.subtle(
                  titleText: 'Envelopes',
                  bodyText: 'Add a transaction to an envelope by tapping it.',
                  leadingIcon: Icons.mail,
                  children: [
                    ModelBuilder(
                      model: envelopesModel,
                      builder: (List<EnvelopeEntity> envelopeEntities) {
                        final envelopeEntitiesByRuleEntries = envelopeEntities
                            .groupListsBy((entity) => entity.value.ruleProperty.value?.runtimeType)
                            .map((ruleType, envelopeEntities) =>
                                MapEntry(envelopeEntities.first.value.ruleProperty.value, envelopeEntities))
                            .entries
                            .sortedBy(
                                (entry) => entry.value.first.value.ruleProperty.value?.priority ?? double.infinity)
                            .toList();

                        return StyledList.column.withMinChildSize(350).centered(
                              children: envelopeEntitiesByRuleEntries.map((entry) {
                                final (rule, envelopeEntities) = entry.asRecord();
                                final envelopeRuleCardModifier = EnvelopeRuleCardModifier.getModifier(rule);

                                return StyledCard.subtle(
                                  titleText: rule?.getDisplayName() ?? 'None',
                                  leading: envelopeRuleCardModifier.getIcon(rule),
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
                                );
                              }).toList(),
                              ifEmptyText: 'You have no envelopes!',
                            );
                      },
                    ),
                  ],
                ),
                StyledCard.subtle(
                  titleText: 'Transactions',
                  bodyText: 'View the transactions in this batch.',
                  leadingIcon: Icons.mail,
                  children: [
                    StyledList.column(
                      children: transactionGeneratorsState.value
                          .map((transactionGenerator) => TransactionCard(
                                budgetTransaction: transactionGenerator.generate(envelopeById),
                                transactionViewContext: TransactionViewContext.budget(currentCents: null),
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
                          for (final transaction in transactions) {
                            final budgetTransactionEntity = BudgetTransactionEntity
                                .constructEntityFromTransactionTypeRuntime(transaction.runtimeType)
                              ..set(transaction);
                            await context.dropCoreComponent.update(budgetTransactionEntity);
                          }
                          for (final entry in modifiedEnvelopeById.entries) {
                            await context.dropCoreComponent.updateEntity(
                              envelopeEntities.firstWhere((entity) => entity.id == entry.key)..set(entry.value),
                            );
                          }
                          context.pop();
                        },
                ),
              ],
            ),
          );
        });
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
          .time
          .compareTo(b.generate(envelopeById).transactionDateProperty.value.time),
    );
    return existingGenerators;
  }

  Widget _buildEnvelopeSelectCard(
    BuildContext context, {
    required EnvelopeEntity envelopeEntity,
    required Map<String, Envelope>? modifiedEnvelopeById,
    required FutureOr Function(BudgetTransaction) onTransactionCreated,
  }) {
    final envelope = envelopeEntity.value;
    final envelopeColor = Color(envelope.colorProperty.value);

    final newEnvelope = modifiedEnvelopeById?[envelopeEntity.id];
    final centDifference =
        newEnvelope == null ? 0 : newEnvelope.amountCentsProperty.value - envelope.amountCentsProperty.value;

    final oldProgress = envelope.ruleProperty.value?.getProgress(envelope);
    final newProgress = newEnvelope?.ruleProperty.value?.getProgress(newEnvelope) ?? oldProgress;

    return Stack(
      children: [
        StyledCard(
          title: StyledList.row(
            children: [
              if (envelope.lockedProperty.value)
                StyledIcon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
              StyledText.h6.withColor(Color(envelope.colorProperty.value))(envelope.nameProperty.value),
            ],
          ),
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit the envelope.',
              iconData: Icons.edit,
              color: Colors.orange,
              onPerform: (context) async {
                await EnvelopeEditDialog.show(
                  context,
                  titleText: 'Edit Envelope',
                  envelope: envelope,
                  onAccept: (Envelope result) async {
                    await context.dropCoreComponent.update(envelopeEntity..value = result);
                  },
                );
              },
            ),
            if (!envelope.lockedProperty.value)
              ActionItem(
                titleText: 'Lock',
                descriptionText: 'Locks this envelope from automatically receiving income.',
                color: Colors.orange,
                iconData: Icons.lock_outline_rounded,
                onPerform: (context) => context.showStyledDialog(StyledDialog.yesNo(
                  titleText: 'Confirm Lock',
                  bodyText: 'Are you sure you want to lock this envelope?',
                  onAccept: () => envelopeEntity.lock(context.dropCoreComponent),
                )),
              ),
            if (envelope.lockedProperty.value)
              ActionItem(
                titleText: 'Unlock',
                descriptionText: 'Unlocks this envelope, which allows it to automatically receive income.',
                color: Colors.orange,
                iconData: Icons.lock_open,
                onPerform: (context) => context.showStyledDialog(StyledDialog.yesNo(
                  titleText: 'Confirm Unlock',
                  bodyText: 'Are you sure you want to unlock this envelope?',
                  onAccept: () => envelopeEntity.unlock(context.dropCoreComponent),
                )),
              ),
            ActionItem(
              titleText: 'Transfer',
              descriptionText: 'Transfer money to/from this envelope.',
              color: Colors.blue,
              iconData: Icons.swap_horiz,
              onPerform: (context) async {
                await TransferTransactionEditDialog.show(
                  context,
                  titleText: 'Create Transfer',
                  sourceEnvelopeEntity: envelopeEntity,
                  transferTransaction: TransferTransaction()..budgetProperty.set(envelope.budgetProperty.value),
                  onAccept: (TransferTransaction result) async {
                    await onTransactionCreated(result);
                  },
                );
              },
            ),
          ],
          onPressed: () async {
            await EnvelopeTransactionEditDialog.show(
              context,
              titleText: 'Create Transaction',
              envelopeTransaction: EnvelopeTransaction()
                ..envelopeProperty.set(envelopeEntity.id!)
                ..budgetProperty.set(envelope.budgetProperty.value),
              onAccept: (EnvelopeTransaction envelopeTransaction) async {
                await onTransactionCreated(envelopeTransaction);
              },
            );
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
        ),
        if (oldProgress != null || newProgress != null)
          Positioned(
            bottom: 1,
            left: 8,
            right: 8,
            child: PercentIndicator(
              percentToColorMap: {
                if (newProgress != null) newProgress: envelopeColor.withOpacity(0.5),
                if (oldProgress != null) oldProgress: envelopeColor,
              },
            ),
          ),
      ],
    );
  }
}

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

    final transactionGeneratorsState = useState<List<TransactionGenerator>>([]);
    final transactions =
        transactionGeneratorsState.value.map((transactionGenerator) => transactionGenerator.generate()).toList();
    final modifiedCentsById = budget != null && envelopeEntities != null
        ? budget
            .addTransactions(
              envelopeById: envelopeEntities.mapToMap((entity) => MapEntry(entity.id!, entity.value)),
              transactions: transactions,
            )
            .modifiedCentsByEnvelopeId
        : null;

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
              final envelopeEntities = await envelopesModel.getOrLoad();

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
                        dropCoreContext: context.dropCoreComponent,
                        envelopeById: envelopeEntities.mapToMap((entity) => MapEntry(entity.id!, entity.value)),
                      ))));

              if (transactionGenerator == null) {
                return;
              }

              transactionGeneratorsState.value =
                  _getSortedTransactionGenerators(transactionGeneratorsState.value + [transactionGenerator]);
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
                                  modifiedCentsById: modifiedCentsById,
                                  onTransactionCreated: (envelopeTransaction) =>
                                      transactionGeneratorsState.value = _getSortedTransactionGenerators(
                                    transactionGeneratorsState.value +
                                        [
                                          WrapperTransactionGenerator(transaction: envelopeTransaction),
                                        ],
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
                children: transactions
                    .map((transaction) => TransactionCard(
                          budgetTransaction: transaction,
                          transactionViewContext: TransactionViewContext.budget(),
                        ))
                    .toList(),
                ifEmptyText: 'No Transactions yet!',
              ),
            ],
          ),
          StyledButton.strong(
            labelText: 'Save',
            iconData: Icons.save,
            onPressed: () async {
              if (modifiedCentsById == null || envelopeEntities == null) {
                return;
              }

              for (final transaction in transactions) {
                final budgetTransactionEntity =
                    BudgetTransactionEntity.constructEntityFromTransactionTypeRuntime(transaction.runtimeType)
                      ..set(transaction);
                await context.dropCoreComponent.update(budgetTransactionEntity);
              }
              for (final entry in modifiedCentsById.entries) {
                await context.dropCoreComponent.updateEntity(
                  envelopeEntities.firstWhere((entity) => entity.id == entry.key),
                  (Envelope envelope) => envelope.amountCentsProperty.set(entry.value),
                );
              }
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  List<TransactionGenerator> _getSortedTransactionGenerators(List<TransactionGenerator> existingGenerators) {
    existingGenerators.sort(
      (a, b) => a.generate().transactionDateProperty.value.compareTo(b.generate().transactionDateProperty.value),
    );
    return existingGenerators;
  }

  StyledCard _buildEnvelopeSelectCard(
    BuildContext context, {
    required EnvelopeEntity envelopeEntity,
    required Map<String, int>? modifiedCentsById,
    required Function(BudgetTransaction) onTransactionCreated,
  }) {
    final envelope = envelopeEntity.value;
    final cents = envelope.amountCentsProperty.value;
    final envelopeCardModification = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);

    final newCents = modifiedCentsById?[envelopeEntity.id];

    return StyledCard(
      titleText: envelope.nameProperty.value,
      leading: envelopeCardModification.getIcon(envelope.ruleProperty.value),
      actions: [
        ActionItem(
          titleText: 'Transfer',
          descriptionText: 'Transfer money to/from this envelope.',
          color: Colors.blue,
          iconData: Icons.swap_horiz,
          onPerform: (context) async {
            final result = await context.showStyledDialog(await TransferTransactionEditDialog.create(
              context,
              titleText: 'Create Transfer',
              sourceEnvelopeEntity: envelopeEntity,
              transferTransaction: TransferTransaction()..budgetProperty.set(envelope.budgetProperty.value),
            ));
            if (result == null) {
              return;
            }

            onTransactionCreated(result);
          },
        ),
      ],
      onPressed: () async {
        final envelopeTransaction = await context.showStyledDialog(EnvelopeTransactionEditDialog(
          corePondContext: context.corePondContext,
          titleText: 'Create Transaction',
          envelopeTransaction: EnvelopeTransaction()
            ..envelopeProperty.set(envelopeEntity.id!)
            ..budgetProperty.set(envelope.budgetProperty.value),
        ));
        if (envelopeTransaction == null) {
          return null;
        }

        onTransactionCreated(envelopeTransaction);
      },
      body: StyledList.row(
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        children: [
          StyledText.body(envelope.amountCentsProperty.value.formatCentsAsCurrency()),
          StyledIcon(Icons.arrow_right),
          if (modifiedCentsById == null) StyledLoadingIndicator(),
          StyledText.body.withColor(newCents == null || newCents == cents
              ? null
              : newCents < cents
                  ? Colors.red
                  : Colors.green)((newCents ?? cents).formatCentsAsCurrency()),
        ],
      ),
    );
  }

  @override
  AddTransactionsPage copy() {
    return AddTransactionsPage();
  }
}

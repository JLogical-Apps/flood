import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:example/presentation/pages/transaction/transaction_generator.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
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
                children: transactions.map((transaction) => TransactionCard(budgetTransaction: transaction)).toList(),
                ifEmptyText: 'No Transactions yet!',
              ),
            ],
          ),
          StyledButton.strong(
            labelText: 'Save',
            iconData: Icons.save,
            onPressed: () async {},
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
    required Function(EnvelopeTransaction) onTransactionCreated,
  }) {
    final envelope = envelopeEntity.value;
    final cents = envelope.amountCentsProperty.value;
    final envelopeCardModification = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);

    final newCents = modifiedCentsById?[envelopeEntity.id];

    return StyledCard(
      titleText: envelope.nameProperty.value,
      leading: envelopeCardModification.getIcon(envelope.ruleProperty.value),
      onPressed: () async {
        final envelopeTransaction = await context.showStyledDialog(EnvelopeTransactionEditDialog(
          titleText: 'Create Transaction',
          envelopeTransactionPort: (EnvelopeTransaction()
                ..envelopeProperty.set(envelopeEntity.id!)
                ..budgetProperty.set(envelope.budgetProperty.value))
              .asPort(context.corePondContext),
        ));
        if (envelopeTransaction == null) {
          return null;
        }

        onTransactionCreated(envelopeTransaction);
      },
      body: StyledList.row(
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        children: [
          StyledText.body(envelope.amountCentsProperty.value.formatCurrency()),
          StyledIcon(Icons.arrow_right),
          if (modifiedCentsById == null) StyledLoadingIndicator(),
          StyledText.body.withColor(newCents == null
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

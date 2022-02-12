import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/budget_transaction/envelope_transaction.dart';
import 'package:example/pond/domain/budget_transaction/transfer_transaction.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransactionCard extends HookWidget {
  final String transactionId;

  const TransactionCard({Key? key, required this.transactionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionEntityController = useEntity<BudgetTransactionEntity>(transactionId);

    return ModelBuilder.styled(
      model: transactionEntityController.model,
      builder: (BudgetTransactionEntity transactionEntity) {
        final transaction = transactionEntity.value;
        if (transaction is EnvelopeTransaction) {
          return StyledContent(
            headerText: transaction.nameProperty.value,
            bodyText: transaction.amountProperty.value!.formatCentsAsCurrency(),
            onTapped: () {
              // context.style().navigateTo(context: context, page: (context) => PondBudgetPage(budgetId: envelopeEntity.id!));
            },
            actions: [
              ActionItem(
                name: 'Delete',
                description: 'Delete this transaction.',
                color: Colors.red,
                leading: Icon(Icons.delete),
                onPerform: () async {
                  final dialog = StyledDialog.yesNo(
                    context: context,
                    titleText: 'Confirm Delete',
                    children: [
                      StyledBodyText('Are you sure you want to delete this transaction?'),
                    ],
                  );
                  if (await dialog.show(context) == true) {
                    await transactionEntity.delete();
                  }
                },
              ),
            ],
          );
        }

        if (transaction is TransferTransaction) {
          final fromEnvelope = useEntity<EnvelopeEntity>(transaction.fromProperty.value!)
              .valueOrNull
              .mapIfPresent((entity) => entity?.value)
              .getOrNull();
          final toEnvelope = useEntity<EnvelopeEntity>(transaction.toProperty.value!)
              .valueOrNull
              .mapIfPresent((entity) => entity?.value)
              .getOrNull();
          return StyledContent(
            headerText: 'Transfer of ${transaction.amountProperty.value!.formatCentsAsCurrency()}',
            bodyText: 'From ${fromEnvelope?.nameProperty.value ?? 'N/A'} to ${toEnvelope?.nameProperty.value ?? 'N/A'}',
            onTapped: () {
              // context.style().navigateTo(context: context, page: (context) => PondBudgetPage(budgetId: envelopeEntity.id!));
            },
            actions: [
              ActionItem(
                name: 'Delete',
                description: 'Delete this transaction.',
                color: Colors.red,
                leading: Icon(Icons.delete),
                onPerform: () async {
                  final dialog = StyledDialog.yesNo(
                    context: context,
                    titleText: 'Confirm Delete',
                    children: [
                      StyledBodyText('Are you sure you want to delete this transaction?'),
                    ],
                  );
                  if (await dialog.show(context) == true) {
                    await transactionEntity.delete();
                  }
                },
              ),
            ],
          );
        }

        throw Exception();
      },
    );
  }
}

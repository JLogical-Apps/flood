
import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/budget_transaction/envelope_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransactionCard extends HookWidget {
  final String transactionId;

  const TransactionCard({Key? key, required this.transactionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transcationEntityController = useEntity<BudgetTransactionEntity>(transactionId);

    return ModelBuilder.styled(
      model: transcationEntityController.model,
      builder: (BudgetTransactionEntity transactionEntity) {
        final transaction = transactionEntity.value;
        if(transaction is EnvelopeTransaction) {
          return StyledContent(
            headerText: transaction.nameProperty.value,
            bodyText: transaction.amountCentsProperty.value!.formatCentsAsCurrency(),
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
                  if (await dialog.show(context)) {
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

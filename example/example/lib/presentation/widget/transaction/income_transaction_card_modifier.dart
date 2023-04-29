import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class IncomeTransactionCardModifier extends TransactionCardModifier<IncomeTransaction> {
  @override
  Widget buildCard(IncomeTransaction transaction, TransactionViewContext transactionViewContext) {
    return StyledCard(
      title: StyledText.h6.withColor(transaction.totalCents >= 0 ? Colors.green : Colors.red)(_getTitleText(
        transactionViewContext: transactionViewContext,
        incomeTransaction: transaction,
      )),
      bodyText: transaction.transactionDateProperty.value.format(showTime: false),
    );
  }

  String _getTitleText({
    required TransactionViewContext transactionViewContext,
    required IncomeTransaction incomeTransaction,
  }) {
    if (transactionViewContext is BudgetTransactionViewContext) {
      return 'Income: ${incomeTransaction.totalCents.formatCentsAsCurrency()}';
    } else if (transactionViewContext is EnvelopeTransactionViewContext) {
      return 'Income: ${incomeTransaction.centsByEnvelopeIdProperty.value[transactionViewContext.envelopeId]?.formatCentsAsCurrency() ?? '?'}';
    }

    throw Exception('Unhandled transaction view context');
  }
}

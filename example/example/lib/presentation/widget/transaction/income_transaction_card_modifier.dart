import 'package:example/features/transaction/income_transaction.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class IncomeTransactionCardModifier extends TransactionCardModifier<IncomeTransaction> {
  @override
  Widget buildCard(IncomeTransaction transaction) {
    final cents =
        transaction.centsByEnvelopeProperty.value.values.fold(0, (int cents, envelopeCents) => cents + envelopeCents);
    return StyledCard(
      title:
          StyledText.h6.withColor(cents >= 0 ? Colors.green : Colors.red)('Income: ${cents.formatCentsAsCurrency()}'),
      bodyText: transaction.transactionDateProperty.value.format(showTime: false),
    );
  }
}

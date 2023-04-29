import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionCardModifier extends TransactionCardModifier<EnvelopeTransaction> {
  @override
  Widget buildCard(EnvelopeTransaction transaction) {
    final cents = transaction.amountCentsProperty.value;
    return StyledCard(
      title: StyledText.h6.withColor(getCentsColor(cents))(cents.formatCentsAsCurrency()),
      bodyText:
          '${transaction.nameProperty.value} - ${transaction.transactionDateProperty.value.format(showTime: false)}',
    );
  }
}

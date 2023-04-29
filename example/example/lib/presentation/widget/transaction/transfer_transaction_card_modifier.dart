import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionCardModifier extends TransactionCardModifier<TransferTransaction> {
  @override
  Widget buildCard(TransferTransaction transaction) {
    return StyledCard(
      titleText: 'Transfer - ${transaction.amountCentsProperty.value.formatCentsAsCurrency()}',
      bodyText: [transaction.nameProperty.value, transaction.transactionDateProperty.value.format(showTime: false)]
          .join(' - '),
    );
  }
}

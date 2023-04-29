import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionPortOverride with IsStyledObjectPortOverride<TransferTransaction> {
  final AppPondContext context;

  TransferTransactionPortOverride({required this.context});

  @override
  Widget build(Port port) {
    return StyledObjectPortBuilder(
      port: port,
      order: [
        TransferTransaction.nameField,
        BudgetTransaction.transactionDateField,
        TransferTransaction.amountCentsField,
      ],
    );
  }
}

import 'package:example_core/features/transaction/budget_transaction.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
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
        BudgetTransaction.transactionDateField,
        TransferTransaction.amountCentsField,
      ],
    );
  }
}

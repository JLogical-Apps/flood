import 'package:example_core/features/transaction/budget_transaction.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionStyledPortOverride with IsStyledObjectPortOverride<EnvelopeTransaction> {
  final AppPondContext context;

  EnvelopeTransactionStyledPortOverride({required this.context});

  @override
  Widget build(Port port) {
    return StyledObjectPortBuilder(
      port: port,
      order: [
        EnvelopeTransaction.nameField,
        EnvelopeTransaction.amountCentsField,
        BudgetTransaction.transactionDateField,
      ],
    );
  }
}

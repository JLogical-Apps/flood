import 'package:example_core/example_core.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionPortOverride with IsStyledObjectPortOverride<EnvelopeTransaction> {
  final AppPondContext context;

  EnvelopeTransactionPortOverride({required this.context});

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

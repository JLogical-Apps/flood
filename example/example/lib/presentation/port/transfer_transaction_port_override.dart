import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
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
        TransferTransaction.amountCentsField,
        BudgetTransaction.transactionDateField,
      ],
      overrides: {
        TransferTransaction.fromEnvelopeField: StyledOptionPortField(
          fieldName: TransferTransaction.fromEnvelopeField,
          labelText: 'From',
          widgetMapper: (EnvelopeEntity? envelopeEntity) => StyledText.body(envelopeEntity?.value.nameProperty.value ?? 'None'),
        ),
        TransferTransaction.toEnvelopeField: StyledOptionPortField(
          fieldName: TransferTransaction.toEnvelopeField,
          labelText: 'To',
          widgetMapper: (EnvelopeEntity? envelopeEntity) => StyledText.body(envelopeEntity?.value.nameProperty.value ?? 'None'),
        ),
      },
    );
  }
}

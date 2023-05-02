import 'dart:async';

import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionEditDialog extends StyledPortDialog<EnvelopeTransaction> {
  EnvelopeTransactionEditDialog._({super.titleText, required super.port, required super.children, super.onAccept});

  factory EnvelopeTransactionEditDialog({
    required CorePondContext corePondContext,
    String? titleText,
    required EnvelopeTransaction envelopeTransaction,
    FutureOr Function(EnvelopeTransaction result)? onAccept,
  }) {
    late Port<Map<String, dynamic>> rawPort;
    final basePort = envelopeTransaction.asPort(
      corePondContext,
      overrides: [
        PortGeneratorOverride.update(EnvelopeTransaction.nameField,
            portFieldUpdater: (portField) => portField.withDynamicFallback(
                () => rawPort['transactionType'] == EnvelopeTransactionType.payment ? 'Payment' : 'Refund'))
      ],
    );
    rawPort = Port.of({
      'transaction': PortField.port(port: basePort),
      'transactionType': PortField.option(
        options: EnvelopeTransactionType.values,
        initialValue: EnvelopeTransactionType.payment,
      ),
    });
    return EnvelopeTransactionEditDialog._(
      titleText: titleText,
      port: rawPort.map((sourceData, port) {
        final transactionResult = sourceData['transaction'] as EnvelopeTransaction;
        final transactionType = sourceData['transactionType'] as EnvelopeTransactionType;
        transactionType.modifyTransaction(transactionResult);
        return transactionResult;
      }),
      children: [
        StyledObjectPortBuilder(port: basePort),
        StyledDivider.subtle(),
        StyledRadioPortField<EnvelopeTransactionType>(
          fieldName: 'transactionType',
          stringMapper: (EnvelopeTransactionType value) => value.name,
        ),
        PortFieldBuilder<EnvelopeTransactionType>(
          fieldName: 'transactionType',
          builder: (context, field, value, error) {
            return StyledText.body(value.note);
          },
        ),
      ],
      onAccept: onAccept,
    );
  }
}

enum EnvelopeTransactionType {
  payment(
    name: 'Payment',
    note: 'Payment from this envelope.',
    transactionModifier: _refundPayment,
  ),
  refund(
    name: 'Refund',
    note: 'Refund to this envelope.',
    transactionModifier: null,
  );

  final String name;
  final String note;
  final void Function(EnvelopeTransaction transaction)? transactionModifier;

  const EnvelopeTransactionType({
    required this.name,
    required this.note,
    required this.transactionModifier,
  });

  void modifyTransaction(EnvelopeTransaction transaction) {
    transactionModifier?.call(transaction);
  }
}

void _refundPayment(EnvelopeTransaction transaction) {
  transaction.amountCentsProperty.set(-transaction.amountCentsProperty.value);
}

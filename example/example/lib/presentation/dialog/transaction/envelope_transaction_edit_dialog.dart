import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionEditDialog extends StyledPortDialog<EnvelopeTransaction> {
  EnvelopeTransactionEditDialog({
    super.titleText,
    required Port<EnvelopeTransaction> envelopeTransactionPort,
  }) : super(
          port: Port.of({
            'transaction': PortField.port(port: envelopeTransactionPort),
            'transactionType': PortField.option(
              options: EnvelopeTransactionType.values,
              initialValue: EnvelopeTransactionType.payment,
            ),
          }).map((sourceData, port) {
            final transactionResult = sourceData['transaction'] as EnvelopeTransaction;
            final transactionType = sourceData['transactionType'] as EnvelopeTransactionType;
            transactionType.modifyTransaction(transactionResult);
            return transactionResult;
          }),
          children: [
            StyledObjectPortBuilder(port: envelopeTransactionPort),
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
        );
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

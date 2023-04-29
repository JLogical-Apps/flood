import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionEditDialog extends StyledPortDialog<TransferTransaction> {
  TransferTransactionEditDialog._({super.titleText, required super.port});

  factory TransferTransactionEditDialog({
    required CorePondContext corePondContext,
    String? titleText,
    required TransferTransaction transferTransaction,
  }) {
    return TransferTransactionEditDialog._(
      titleText: titleText,
      port: transferTransaction.asPort(
        corePondContext,
        overrides: [
          PortGeneratorOverride.update(TransferTransaction.nameField,
              portFieldUpdater: (portField) => portField.withFallback('Transfer')),
          PortGeneratorOverride.override(
            TransferTransaction.fromEnvelopeField,
            portField: PortField.option<EnvelopeEntity?, String>(
              options: [
                null,
                EnvelopeEntity()
                  ..id = '35'
                  ..set(Envelope()..nameProperty.set('Kachow')),
              ],
              initialValue: null,
              submitMapper: (envelopeEntity) => envelopeEntity!.id!,
            ).isNotNull(),
          ),
          PortGeneratorOverride.override(
            TransferTransaction.toEnvelopeField,
            portField: PortField.option<EnvelopeEntity?, String>(
              options: [
                null,
                EnvelopeEntity()
                  ..id = '35'
                  ..set(Envelope()..nameProperty.set('Kachow')),
              ],
              initialValue: null,
              submitMapper: (envelopeEntity) => envelopeEntity!.id!,
            ).isNotNull(),
          ),
        ],
      ),
    );
  }
}

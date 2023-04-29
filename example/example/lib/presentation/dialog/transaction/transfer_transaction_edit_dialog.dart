import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionEditDialog extends StyledPortDialog<TransferTransaction> {
  TransferTransactionEditDialog._({super.titleText, required super.port});

  static Future<TransferTransactionEditDialog> create(
    BuildContext context, {
    String? titleText,
    required TransferTransaction transferTransaction,
  }) async {
    final envelopeEntities = await context.dropCoreComponent
        .executeQuery(EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: transferTransaction.budgetProperty.value).all());
    return TransferTransactionEditDialog._(
      titleText: titleText,
      port: transferTransaction.asPort(
        context.corePondContext,
        overrides: [
          PortGeneratorOverride.update(TransferTransaction.nameField,
              portFieldUpdater: (portField) => portField.withFallback('Transfer')),
          PortGeneratorOverride.override(
            TransferTransaction.fromEnvelopeField,
            portField: PortField.option<EnvelopeEntity?, String>(
              options: [
                null,
                ...envelopeEntities,
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
                ...envelopeEntities,
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

import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/budget_transaction/transfer_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionEntity extends BudgetTransactionEntity<TransferTransaction> {
  @override
  Future<void> beforeSave() async {
    late int centsToAdd;

    final oldEntity = await AppContext.global.executeQuery(Query.getById<TransferTransactionEntity>(id!));
    if (oldEntity == null) {
      centsToAdd = value.amountProperty.value!;
    } else {
      final oldTransaction = oldEntity.value;

      centsToAdd = value.amountProperty.value! - oldTransaction.amountProperty.value!;
    }

    await _adjustEnvelopeAmount(centsToAdd);
  }

  @override
  Future<void> beforeDelete() async {
    await _adjustEnvelopeAmount(-value.amountProperty.value!);
  }

  Future<void> _adjustEnvelopeAmount(int centsToAdd) async {
    final fromEnvelopeEntity = await value.fromProperty.loadOrNull();
    if (fromEnvelopeEntity != null) {
      final fromEnvelope = fromEnvelopeEntity.value;
      fromEnvelope.amountProperty.value = fromEnvelope.amountProperty.value! - centsToAdd;
      await fromEnvelopeEntity.save();
    }

    final toEnvelopeEntity = await value.toProperty.loadOrNull();
    if (toEnvelopeEntity != null) {
      final toEnvelope = toEnvelopeEntity.value;
      toEnvelope.amountProperty.value = toEnvelope.amountProperty.value! + centsToAdd;
      await toEnvelopeEntity.save();
    }
  }
}

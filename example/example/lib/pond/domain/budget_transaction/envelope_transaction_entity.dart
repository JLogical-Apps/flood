import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope_transaction.dart';

class EnvelopeTransactionEntity extends BudgetTransactionEntity<EnvelopeTransaction> {
  @override
  Future<void> beforeSave() async {
    late int centsToAdd;

    final oldEntity = await AppContext.global.executeQuery(Query.getById<EnvelopeTransactionEntity>(id!));
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
    final envelopeEntity = await value.envelopeProperty.loadOrNull();
    if (envelopeEntity == null) {
      return;
    }

    final envelope = envelopeEntity.value;
    envelope.amountProperty.value = envelope.amountProperty.value! + centsToAdd;
    await envelopeEntity.save();
  }
}

import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';

import 'envelope_transaction.dart';

class EnvelopeTransactionEntity extends BudgetTransactionEntity<EnvelopeTransaction> {
  @override
  Future<void> beforeDelete() async {
    await super.beforeDelete();

    final envelopeEntity = await value.envelopeProperty.loadOrNull();
    if (envelopeEntity == null) {
      return;
    }

    final envelope = envelopeEntity.value;
    envelope.amountProperty.value = envelope.amountProperty.value! - value.amountCentsProperty.value!;
    await envelopeEntity.save();
  }
}

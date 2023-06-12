import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionEntity extends BudgetTransactionEntity<EnvelopeTransaction> {
  @override
  Future<void> onBeforeSave(CoreDropContext context) async {
    if (isNew) {
      return;
    }

    final oldEntity = await Query.getByIdOrNull<EnvelopeTransactionEntity>(id!).get(context) ??
        (throw Exception('Could not find envelope transaction with id [$id]'));

    final oldTransaction = oldEntity.value;

    final centsToAdd = value.amountCentsProperty.value - oldTransaction.amountCentsProperty.value;

    await _adjustEnvelopeAmount(context, centsToAdd: centsToAdd);
  }

  @override
  Future<void> onBeforeDelete(CoreDropContext context) async {
    await _adjustEnvelopeAmount(context, centsToAdd: -value.amountCentsProperty.value);
  }

  Future<void> _adjustEnvelopeAmount(CoreDropContext context, {required int centsToAdd}) async {
    final envelopeEntity = await value.envelopeProperty.load(context);
    if (envelopeEntity == null) {
      return;
    }

    await context.updateEntity(
      envelopeEntity,
      (Envelope envelope) => envelope.amountCentsProperty.set(envelope.amountCentsProperty.value + centsToAdd),
    );
  }
}

import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class EnvelopeTransactionEntity extends BudgetTransactionEntity<EnvelopeTransaction> {
  @override
  Future<void> onBeforeSave(DropCoreContext context) async {
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
  Future<void> onBeforeDelete(DropCoreContext context) async {
    await _adjustEnvelopeAmount(context, centsToAdd: -value.amountCentsProperty.value);
  }

  Future<void> _adjustEnvelopeAmount(DropCoreContext context, {required int centsToAdd}) async {
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
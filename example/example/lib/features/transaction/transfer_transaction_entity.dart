import 'dart:async';

import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionEntity extends BudgetTransactionEntity<TransferTransaction> {
  @override
  FutureOr onBeforeSave(CoreDropContext context) async {
    if (isNew) {
      return;
    }

    final oldEntity = await Query.getByIdOrNull<TransferTransactionEntity>(id!).get(context) ??
        (throw Exception('Could not find transfer transaction with id [$id]'));

    final oldTransaction = oldEntity.value;
    final centsToAdd = value.amountCentsProperty.value - oldTransaction.amountCentsProperty.value;

    await _adjustEnvelopeAmount(context, centsToAdd: centsToAdd);
  }

  @override
  FutureOr onBeforeDelete(CoreDropContext context) async {
    await _adjustEnvelopeAmount(context, centsToAdd: -value.amountCentsProperty.value);
  }

  Future<void> _adjustEnvelopeAmount(CoreDropContext context, {required int centsToAdd}) async {
    final fromEnvelopeEntity = await value.fromEnvelopeProperty.load(context);
    final toEnvelopeEntity = await value.toEnvelopeProperty.load(context);

    if (fromEnvelopeEntity == null || toEnvelopeEntity == null) {
      return;
    }

    await context.updateEntity(
      fromEnvelopeEntity,
      (Envelope envelope) => envelope.amountCentsProperty.set(envelope.amountCentsProperty.value - centsToAdd),
    );

    await context.updateEntity(
      toEnvelopeEntity,
      (Envelope envelope) => envelope.amountCentsProperty.set(envelope.amountCentsProperty.value + centsToAdd),
    );
  }
}

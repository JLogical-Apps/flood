import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class IncomeTransactionEntity extends BudgetTransactionEntity<IncomeTransaction> {
  @override
  Future<void> onBeforeDelete(DropCoreContext context) async {
    await _adjustEnvelopeAmount(
      context,
      centsToAddByEnvelopeId: value.centsByEnvelopeIdProperty.value.map((id, cents) => MapEntry(id, -cents)),
    );
  }

  Future<void> _adjustEnvelopeAmount(
    DropCoreContext context, {
    required Map<String, int> centsToAddByEnvelopeId,
  }) async {
    final envelopeEntities = await Future.wait(
        centsToAddByEnvelopeId.keys.map((id) => Query.getByIdOrNull<EnvelopeEntity>(id).get(context)));

    await Future.wait(envelopeEntities.map((entity) async {
      final envelope = entity?.value;
      if (envelope == null) {
        return;
      }

      final incomeCents = centsToAddByEnvelopeId[entity!.id!]!;

      final envelopeChange = envelope.ruleProperty.value?.onAddIncome(
        context,
        incomeCents: incomeCents,
        envelope: envelope,
      );

      await context.updateEntity(
        entity,
        (Envelope envelope) {
          envelope.amountCentsProperty.set(envelope.amountCentsProperty.value + incomeCents);
          if (envelopeChange?.ruleChange != null) {
            envelope.ruleProperty.set(envelopeChange!.ruleChange!);
          }
        },
      );
    }));
  }
}

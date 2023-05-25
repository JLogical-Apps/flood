import 'package:example/features/budget/budget.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class BudgetEntity extends Entity<Budget> {
  Future<B> updateAddTransaction<B extends BudgetTransactionEntity>(
    DropCoreContext context, {
    required B transactionEntity,
  }) async {
    final envelopeEntities =
        await EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: id!, isArchived: null).all().get(context);
    final envelopeById = envelopeEntities.mapToMap((entity) => MapEntry(entity.id!, entity.value));
    final budgetChange = transactionEntity.value.getBudgetChange(context, envelopeById: envelopeById);

    await Future.wait(budgetChange.modifiedEnvelopeById.mapToIterable((envelopeId, envelope) async {
      final envelopeEntity = envelopeEntities.firstWhere((entity) => entity.id == envelopeId);
      await context.updateEntity(envelopeEntity..set(envelope));
    }));

    return await context.updateEntity(transactionEntity);
  }
}

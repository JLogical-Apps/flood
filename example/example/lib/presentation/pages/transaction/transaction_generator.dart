import 'package:example_core/example_core.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class TransactionGenerator<B extends BudgetTransaction> {
  B generate(Map<String, Envelope> envelopeById);
}

class WrapperTransactionGenerator<B extends BudgetTransaction> extends TransactionGenerator<B> {
  final B transaction;

  WrapperTransactionGenerator({required this.transaction});

  @override
  B generate(Map<String, Envelope> envelopeById) {
    return transaction;
  }
}

class IncomeTransactionGenerator extends TransactionGenerator<IncomeTransaction> {
  final int incomeCents;
  final DateTime transactionDate;

  final String budgetId;
  final Budget budget;
  final DropCoreContext dropCoreContext;

  IncomeTransactionGenerator({
    required this.incomeCents,
    required this.transactionDate,
    required this.budgetId,
    required this.budget,
    required this.dropCoreContext,
  });

  @override
  IncomeTransaction generate(Map<String, Envelope> envelopeById) {
    final budgetChange = budget.addIncome(
      dropCoreContext,
      incomeCents: incomeCents,
      envelopeById: envelopeById,
    );
    return IncomeTransaction()
      ..centsByEnvelopeIdProperty.set(budgetChange.modifiedEnvelopeById.map((id, envelope) =>
          MapEntry(id, envelope.amountCentsProperty.value - envelopeById[id]!.amountCentsProperty.value)))
      ..transactionDateProperty.set(Timestamp.of(transactionDate))
      ..budgetProperty.set(budgetId);
  }
}

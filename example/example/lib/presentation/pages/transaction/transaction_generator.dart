import 'package:example/features/budget/budget.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class TransactionGenerator<B extends BudgetTransaction> {
  B generate();
}

class WrapperTransactionGenerator<B extends BudgetTransaction> extends TransactionGenerator<B> {
  final B transaction;

  WrapperTransactionGenerator({required this.transaction});

  @override
  B generate() {
    return transaction;
  }
}

class IncomeTransactionGenerator extends TransactionGenerator<IncomeTransaction> {
  final int incomeCents;
  final DateTime transactionDate;

  final String budgetId;
  final Budget budget;
  final DropCoreContext dropCoreContext;
  final Map<String, Envelope> envelopeById;

  IncomeTransactionGenerator({
    required this.incomeCents,
    required this.transactionDate,
    required this.budgetId,
    required this.budget,
    required this.dropCoreContext,
    required this.envelopeById,
  });

  @override
  IncomeTransaction generate() {
    final budgetChange =
        budget.addIncome(context: dropCoreContext, incomeCents: incomeCents, envelopeById: envelopeById);
    return IncomeTransaction()
      ..centsByEnvelopeIdProperty.set(budgetChange.modifiedCentsByEnvelopeId)
      ..transactionDateProperty.set(transactionDate)
      ..budgetProperty.set(budgetId);
  }
}

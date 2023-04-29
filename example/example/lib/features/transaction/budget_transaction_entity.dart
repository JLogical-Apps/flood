import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/envelope_transaction_entity.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:example/features/transaction/income_transaction_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/features/transaction/transfer_transaction_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {
  static Query<BudgetTransactionEntity> getBudgetTransactionsQuery({required String budgetId}) {
    return Query.from<BudgetTransactionEntity>()
        .where(BudgetTransaction.budgetField)
        .isEqualTo(budgetId)
        .orderByDescending(BudgetTransaction.transactionDateField);
  }

  static Query<BudgetTransactionEntity> getEnvelopeTransactionsQuery({required String envelopeId}) {
    return Query.from<BudgetTransactionEntity>()
        .where(BudgetTransaction.affectedEnvelopesField)
        .contains(envelopeId)
        .orderByDescending(BudgetTransaction.transactionDateField);
  }

  static BudgetTransactionEntity constructEntityFromTransactionTypeRuntime(Type budgetTransactionType) {
    if (budgetTransactionType == EnvelopeTransaction) {
      return EnvelopeTransactionEntity();
    } else if (budgetTransactionType == IncomeTransaction) {
      return IncomeTransactionEntity();
    } else if (budgetTransactionType == TransferTransaction) {
      return TransferTransactionEntity();
    }
    throw Exception('Could not find entity for budget transaction [$budgetTransactionType]!');
  }
}

import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/envelope_transaction_entity.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:example/features/transaction/income_transaction_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/features/transaction/transfer_transaction_entity.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {
  static Query<BudgetTransactionEntity> getBudgetTransactionsQuery({required String budgetId}) {
    return Query.from<BudgetTransactionEntity>().where(BudgetTransaction.budgetField).isEqualTo(budgetId);
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

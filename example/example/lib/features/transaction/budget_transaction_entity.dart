import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {
  static Query<BudgetTransactionEntity> getBudgetTransactionsQuery({required String budgetId}) {
    return Query.from<BudgetTransactionEntity>().where(BudgetTransaction.budgetField).isEqualTo(budgetId);
  }
}

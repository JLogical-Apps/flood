import 'package:jlogical_utils/jlogical_utils.dart';
import 'budget_transaction.dart';

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {
  static Query<BudgetTransactionEntity> getBudgetTransactionsQueryFromBudget(String budgetId) {
    return Query.from<BudgetTransactionEntity>().where(BudgetTransaction.budgetField, isEqualTo: budgetId);
  }
}

import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';
import 'budget_transaction_entity.dart';

class LocalBudgetTransactionRepository extends DefaultLocalRepository<BudgetTransactionEntity, BudgetTransaction> {
  @override
  BudgetTransactionEntity createEntity() {
    return BudgetTransactionEntity();
  }

  @override
  BudgetTransaction createValueObject() {
    return BudgetTransaction();
  }
}

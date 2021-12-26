import 'package:jlogical_utils/src/pond/record/entity.dart';

import 'budget_transaction.dart';

abstract class BudgetTransactionEntity<BT extends BudgetTransaction> extends Entity<BT> {
  BudgetTransactionEntity({required BT initialValue}) : super(initialValue: initialValue);
}

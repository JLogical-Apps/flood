import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';
import 'budget_transaction_entity.dart';

class LocalBudgetTransactionRepository extends EntityRepository
    with
        WithMonoEntityRepository<BudgetTransactionEntity>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithDomainRegistrationsProvider<BudgetTransaction, BudgetTransactionEntity>,
        WithTransactionsAndCacheEntityRepository
    implements RegistrationsProvider {
  @override
  BudgetTransactionEntity createEntity(BudgetTransaction initialValue) {
    return BudgetTransactionEntity(initialValue: initialValue);
  }

  @override
  BudgetTransaction createValueObject() {
    return BudgetTransaction();
  }
}

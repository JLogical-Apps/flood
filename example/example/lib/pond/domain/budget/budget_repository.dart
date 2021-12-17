import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget.dart';
import 'budget_aggregate.dart';
import 'budget_entity.dart';

class LocalBudgetRepository extends EntityRepository<BudgetEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<Budget, BudgetEntity>
    implements RegistrationsProvider {
  @override
  BudgetEntity createEntity(Budget initialValue) {
    return BudgetEntity(initialValue: initialValue);
  }

  @override
  Budget createValueObject() {
    return Budget();
  }

  @override
  AggregateRegistration<BudgetAggregate, BudgetEntity> get aggregateRegistration =>
      AggregateRegistration((entity) => BudgetAggregate(initialBudgetEntity: entity));
}

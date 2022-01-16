import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget.dart';
import 'budget_aggregate.dart';
import 'budget_entity.dart';

class BudgetRepository extends DefaultAdaptingRepository<BudgetEntity, Budget> {
  final Directory baseDirectory;

  BudgetRepository({required this.baseDirectory});

  @override
  BudgetEntity createEntity() {
    return BudgetEntity();
  }

  @override
  Budget createValueObject() {
    return Budget();
  }

  @override
  AggregateRegistration<BudgetAggregate, BudgetEntity> get aggregateRegistration =>
      AggregateRegistration((entity) => BudgetAggregate());
}

import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget.dart';
import 'budget_entity.dart';

class BudgetRepository extends DefaultAdaptingRepository<BudgetEntity, Budget> {
  @override
  String get dataPath => 'budgets';

  @override
  BudgetEntity createEntity() {
    return BudgetEntity();
  }

  @override
  Budget createValueObject() {
    return Budget();
  }
}

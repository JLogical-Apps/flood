import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget.dart';
import 'budget_entity.dart';

class BudgetAggregate extends Aggregate<BudgetEntity> {
  Future<void> edit(Budget newBudget) async {
    entity.value = newBudget;
    await entity.save();
  }
}

import 'package:jlogical_utils/src/pond/context/resolvable.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';

import 'budget_entity.dart';

class BudgetAggregate extends Aggregate<BudgetEntity> {
  BudgetAggregate({required BudgetEntity budgetEntity}) : super(entity: budgetEntity);

  List<Resolvable> get resolvables => [entity];
}

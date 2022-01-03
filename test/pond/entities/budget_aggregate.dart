import 'package:jlogical_utils/src/pond/utils/resolvable.dart';
import 'package:jlogical_utils/src/pond/record/aggregate.dart';

import 'budget_entity.dart';

class BudgetAggregate extends Aggregate<BudgetEntity> {
  List<Resolvable> get resolvables => [entity];
}

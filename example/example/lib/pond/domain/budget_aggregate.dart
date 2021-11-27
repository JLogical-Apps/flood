import 'package:example/pond/domain/budget.dart';
import 'package:example/pond/domain/budget_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetAggregate extends Aggregate<BudgetEntity> {
  BudgetAggregate({required BudgetEntity initialBudgetEntity}) : super(entity: initialBudgetEntity);

  Future<void> edit(Budget newBudget) async {
    entity.value = newBudget;
    save();
  }
}

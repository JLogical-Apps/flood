import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class BudgetRepository with IsRepositoryWrapper {
  @override
  Repository get repository => Repository.memory().forType<BudgetEntity, Budget>(
        BudgetEntity.new,
        Budget.new,
        entityTypeName: 'BudgetEntity',
        valueObjectTypeName: 'Budget',
      );
}

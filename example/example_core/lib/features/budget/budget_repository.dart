import 'package:example_core/features/budget/budget.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class BudgetRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.adapting('budget')
      .forType<BudgetEntity, Budget>(
        BudgetEntity.new,
        Budget.new,
        entityTypeName: 'BudgetEntity',
        valueObjectTypeName: 'Budget',
      )
      .withSecurity(RepositorySecurity.authenticated());
}

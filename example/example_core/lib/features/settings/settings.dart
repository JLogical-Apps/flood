import 'package:example_core/features/budget/budget_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Settings extends ValueObject {
  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField);

  @override
  late final List<ValueObjectBehavior> behaviors = [
    budgetProperty,
  ];
}

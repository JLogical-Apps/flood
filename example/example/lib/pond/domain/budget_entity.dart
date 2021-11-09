import 'package:example/pond/domain/budget.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetEntity extends Entity<Budget> {
  BudgetEntity({required Budget initialBudget}) : super(initialValue: initialBudget);
}
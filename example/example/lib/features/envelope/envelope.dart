import 'package:example/features/budget/budget_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class Envelope extends ValueObject {
  late final nameProperty = field<String>(name: 'name').required();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, budgetProperty];
}

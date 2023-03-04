import 'package:example/features/budget/budget_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Envelope extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).isNotBlank();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  static const amountCentsField = 'amount';
  late final amountCentsProperty = field<int>(name: amountCentsField).withFallback(() => 0);

  @override
  List<ValueObjectBehavior> get behaviors => [
        nameProperty,
        budgetProperty,
        amountCentsProperty,
      ];
}

import 'package:example/features/budget/budget_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Tray extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const descriptionField = 'description';
  late final descriptionProperty = field<String>(name: descriptionField).withDisplayName('Description').multiline();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  static const colorField = 'color';
  late final colorProperty =
      field<int>(name: colorField).withDisplayName('Color').color().withFallback(() => 0xffffffff);

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    descriptionProperty,
    budgetProperty,
    colorProperty,
    creationTime(),
  ];
}

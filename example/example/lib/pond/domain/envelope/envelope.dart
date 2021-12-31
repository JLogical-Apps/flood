import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class Envelope extends ValueObject {
  static const String nameField = 'name';
  late final nameProperty = FieldProperty<String>(name: nameField).required();

  static const String budgetField = 'budget';
  late final budgetProperty = ReferenceFieldProperty<BudgetEntity>(name: budgetField).required();

  late final amountProperty = FieldProperty<int>(name: 'amount').required();

  @override
  List<Property> get properties => super.properties + [nameProperty, budgetProperty];
}

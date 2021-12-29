import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_entity.dart';

abstract class BudgetTransaction extends ValueObject {
  late final budgetProperty = ReferenceFieldProperty<BudgetEntity>(name: 'budget');

  @override
  List<Property> get properties => [budgetProperty];
}

import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';

class EnvelopeTransaction extends BudgetTransaction {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final amountProperty = FieldProperty<int>(name: 'amount').required();

  @override
  List<Property> get properties => super.properties + [nameProperty, amountProperty];
}

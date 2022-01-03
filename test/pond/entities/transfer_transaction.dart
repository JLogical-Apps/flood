import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';

class TransferTransaction extends BudgetTransaction {
  late final amountProperty = FieldProperty<int>(name: 'amount').required();

  @override
  List<Property> get properties => super.properties + [amountProperty];
}
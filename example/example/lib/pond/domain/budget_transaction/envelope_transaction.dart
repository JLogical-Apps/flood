import 'package:example/pond/domain/budget_transaction/budget_transaction.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransaction extends BudgetTransaction {
  late final nameProperty = FieldProperty<String>(name: 'name').required();

  late final amountCentsProperty = FieldProperty<int>(name: 'amount').required();

  @override
  List<Property> get properties => super.properties + [nameProperty, amountCentsProperty];
}
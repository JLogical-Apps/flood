import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class AmountTransaction extends BudgetTransaction {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).isNotBlank();

  static const amountCentsField = 'amount';
  late final amountCentsProperty = field<int>(name: amountCentsField).withFallback(() => 0);

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [nameProperty, amountCentsProperty];
}

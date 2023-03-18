import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class IncomeTransaction extends BudgetTransaction {
  static const centsByEnvelopeField = 'centsByEnvelope';
  late final centsByFieldProperty = field<String>(name: centsByEnvelopeField).mapTo<int>();

  @override
  List<String> get affectedEnvelopeIds => centsByFieldProperty.value.keys.toList();

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [centsByFieldProperty];
}

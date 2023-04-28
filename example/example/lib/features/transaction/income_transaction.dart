import 'package:example/features/budget/budget_change.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class IncomeTransaction extends BudgetTransaction {
  static const centsByEnvelopeField = 'centsByEnvelope';
  late final centsByEnvelopeProperty = field<String>(name: centsByEnvelopeField).mapTo<int>();

  @override
  List<String> get affectedEnvelopeIds => centsByEnvelopeProperty.value.keys.toList();

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [centsByEnvelopeProperty];

  @override
  BudgetChange getBudgetChange({required Map<String, int> centsByEnvelopeId}) {
    return BudgetChange(
        modifiedCentsByEnvelopeId: centsByEnvelopeId
            .map((envelopeId, cents) => MapEntry(envelopeId, (centsByEnvelopeProperty.value[envelopeId] ?? 0) + cents)),
        isIncome: true);
  }
}

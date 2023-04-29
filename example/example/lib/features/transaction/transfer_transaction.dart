import 'package:example/features/budget/budget_change.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TransferTransaction extends BudgetTransaction {
  static const fromEnvelopeField = 'from';
  late final fromEnvelopeProperty = reference<EnvelopeEntity>(name: fromEnvelopeField).required().hidden();

  static const toEnvelopeField = 'to';
  late final toEnvelopeProperty = reference<EnvelopeEntity>(name: toEnvelopeField).required().hidden();

  static const amountCentsField = 'amount';
  late final amountCentsProperty = field<int>(name: amountCentsField)
      .withDisplayName('Amount (\$)')
      .currency()
      .withFallback(() => 0)
      .requiredOnEdit();

  @override
  List<String> get affectedEnvelopeIds => [fromEnvelopeProperty.value, toEnvelopeProperty.value];

  @override
  List<ValueObjectBehavior> get behaviors =>
      super.behaviors +
      [
        fromEnvelopeProperty,
        toEnvelopeProperty,
        amountCentsProperty,
      ];

  @override
  BudgetChange getBudgetChange({required Map<String, int> centsByEnvelopeId}) {
    final fromEnvelopeCents = centsByEnvelopeId[fromEnvelopeProperty.value];
    final toEnvelopeCents = centsByEnvelopeId[toEnvelopeProperty.value];
    if (fromEnvelopeCents == null || toEnvelopeCents == null) {
      return BudgetChange(
        modifiedCentsByEnvelopeId: centsByEnvelopeId,
        isIncome: false,
      );
    }

    return BudgetChange(
      modifiedCentsByEnvelopeId: centsByEnvelopeId.copy()
        ..set(fromEnvelopeProperty.value, fromEnvelopeCents - amountCentsProperty.value)
        ..set(toEnvelopeProperty.value, toEnvelopeCents + amountCentsProperty.value),
      isIncome: false,
    );
  }
}

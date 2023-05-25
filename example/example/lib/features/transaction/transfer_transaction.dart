import 'package:example/features/budget/budget_change.dart';
import 'package:example/features/envelope/envelope.dart';
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
  BudgetChange getBudgetChange(DropCoreContext context, {required Map<String, Envelope> envelopeById}) {
    final fromEnvelope = envelopeById[fromEnvelopeProperty.value];
    final toEnvelope = envelopeById[toEnvelopeProperty.value];
    if (fromEnvelope == null || toEnvelope == null) {
      return BudgetChange(modifiedEnvelopeById: envelopeById);
    }

    return BudgetChange(
      modifiedEnvelopeById: envelopeById.copy()
        ..set(
          fromEnvelopeProperty.value,
          fromEnvelope.withUpdatedCents(context, (currentCents) => currentCents - amountCentsProperty.value),
        )
        ..set(
          toEnvelopeProperty.value,
          toEnvelope.withUpdatedCents(context, (currentCents) => currentCents + amountCentsProperty.value),
        ),
    );
  }
}

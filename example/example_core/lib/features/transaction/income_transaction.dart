import 'package:example_core/features/budget/budget_change.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class IncomeTransaction extends BudgetTransaction {
  static const centsByEnvelopeField = 'centsByEnvelope';
  late final centsByEnvelopeIdProperty = field<String>(name: centsByEnvelopeField).mapTo<int>();

  @override
  List<String> get affectedEnvelopeIds => centsByEnvelopeIdProperty.value.keys.toList();

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [centsByEnvelopeIdProperty];

  int get totalCents =>
      centsByEnvelopeIdProperty.value.values.fold(0, (int cents, envelopeCents) => cents + envelopeCents);

  @override
  BudgetChange getBudgetChange(CoreDropContext context, {required Map<String, Envelope> envelopeById}) {
    return BudgetChange(
      modifiedEnvelopeById: envelopeById.map(
        (envelopeId, envelope) => MapEntry(
            envelopeId,
            envelope.withIncomeAdded(
              context,
              incomeCents: centsByEnvelopeIdProperty.value[envelopeId] ?? 0,
            )),
      ),
    );
  }
}

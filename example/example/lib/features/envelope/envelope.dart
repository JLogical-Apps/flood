import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Envelope extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).isNotBlank();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  static const amountCentsField = 'amount';
  late final amountCentsProperty = field<int>(name: amountCentsField).withFallback(() => 0);

  static const ruleField = 'rule';
  late final ruleProperty = field<EnvelopeRule>(name: ruleField);

  static const lockedField = 'locked';
  late final lockedProperty = field<bool>(name: lockedField).withFallback(() => false);

  @override
  List<ValueObjectBehavior> get behaviors => [
        nameProperty,
        budgetProperty,
        amountCentsProperty,
        ruleProperty,
        lockedProperty,
      ];

  /// Returns a copy of the envelope with the [incomeCents] gained and a possibly modified envelope rule.
  /// If [incomeCents] is negative, then an income transaction has been deleted from the envelope.
  Envelope withIncomeAdded({required DropCoreContext context, required int incomeCents}) {
    final envelopeChange = ruleProperty.value?.onAddIncome(
      context: context,
      envelope: this,
      incomeCents: incomeCents,
    );

    final newCents = amountCentsProperty.value + incomeCents;
    final newEnvelopeRule = envelopeChange?.ruleChange ?? ruleProperty.value;

    return Envelope()
      ..copyFrom(context, this)
      ..amountCentsProperty.set(newCents)
      ..ruleProperty.set(newEnvelopeRule);
  }
}

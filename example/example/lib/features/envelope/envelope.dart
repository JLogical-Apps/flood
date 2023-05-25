import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Envelope extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const descriptionField = 'description';
  late final descriptionProperty = field<String>(name: descriptionField).withDisplayName('Description').multiline();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  static const amountCentsField = 'amount';
  late final amountCentsProperty =
      field<int>(name: amountCentsField).withDisplayName('Amount').currency().hidden().withFallback(() => 0);

  static const ruleField = 'rule';
  late final ruleProperty = field<EnvelopeRule>(name: ruleField).withDisplayName('Rule');

  static const colorField = 'color';
  late final colorProperty =
      field<int>(name: colorField).withDisplayName('Color').color().withFallback(() => 0xffffffff);

  static const archivedField = 'archived';
  late final archivedProperty = field<bool>(name: archivedField).hidden().withFallback(() => false);

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    descriptionProperty,
    budgetProperty,
    amountCentsProperty,
    ruleProperty,
    colorProperty,
    archivedProperty,
    creationTime(),
  ];

  Envelope copy(DropCoreContext context) {
    return Envelope()..copyFrom(context, this);
  }

  Envelope withUpdatedCents(DropCoreContext context, int Function(int currentCents) centsGetter) {
    return copy(context)..amountCentsProperty.set(centsGetter(amountCentsProperty.value));
  }

  /// Returns a copy of the envelope with the [incomeCents] gained and a possibly modified envelope rule.
  /// If [incomeCents] is negative, then an income transaction has been deleted from the envelope.
  Envelope withIncomeAdded(DropCoreContext context, {required int incomeCents}) {
    final envelopeChange = ruleProperty.value?.onAddIncome(
      context,
      envelope: this,
      incomeCents: incomeCents,
    );

    final newCents = amountCentsProperty.value + incomeCents;
    final newEnvelopeRule = envelopeChange?.ruleChange ?? ruleProperty.value;

    return copy(context)
      ..amountCentsProperty.set(newCents)
      ..ruleProperty.set(newEnvelopeRule);
  }
}

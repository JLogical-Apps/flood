import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class EnvelopeTransaction extends BudgetTransaction {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const envelopeField = 'envelope';
  late final envelopeProperty = reference<EnvelopeEntity>(name: envelopeField).required();

  static const amountCentsField = 'amount';
  late final amountCentsProperty = field<int>(name: amountCentsField)
      .withDisplayName('Amount')
      .requiredOnEdit()
      .currency()
      .withFallbackReplacement(() => 0);

  @override
  List<String> get affectedEnvelopeIds => [envelopeProperty.value];

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [nameProperty, envelopeProperty, amountCentsProperty];
}

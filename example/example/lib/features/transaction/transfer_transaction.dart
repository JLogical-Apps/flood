import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TransferTransaction extends BudgetTransaction {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const fromEnvelopeField = 'from';
  late final fromEnvelopeProperty = reference<EnvelopeEntity>(name: fromEnvelopeField).required();

  static const toEnvelopeField = 'to';
  late final toEnvelopeProperty = reference<EnvelopeEntity>(name: toEnvelopeField).required();

  static const amountCentsField = 'amount';
  late final amountCentsProperty =
      field<int>(name: amountCentsField).withDisplayName('Amount (\$)').withFallback(() => 0);

  @override
  List<String> get affectedEnvelopeIds => [fromEnvelopeProperty.value, toEnvelopeProperty.value];

  @override
  List<ValueObjectBehavior> get behaviors =>
      super.behaviors +
      [
        nameProperty,
        fromEnvelopeProperty,
        toEnvelopeProperty,
        amountCentsProperty,
      ];
}

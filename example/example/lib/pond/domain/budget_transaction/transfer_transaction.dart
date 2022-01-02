import 'package:example/pond/domain/budget_transaction/budget_transaction.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransaction extends BudgetTransaction {
  late final fromProperty = ReferenceFieldProperty<EnvelopeEntity>(name: 'from')..required();
  late final toProperty = ReferenceFieldProperty<EnvelopeEntity>(name: 'to')..required();
  late final amountCentsProperty = FieldProperty<int>(name: 'amount').required();

  @override
  Property<List<String>> get abstractAffectedEnvelopesProperty => ListComputedProperty(
        name: BudgetTransaction.affectedEnvelopesField,
        computation: () => [
          fromProperty.value!,
          toProperty.value!,
        ],
      );

  @override
  List<Property> get properties => super.properties + [fromProperty, toProperty, amountCentsProperty];
}

import 'package:example/pond/domain/budget_transaction/budget_transaction.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransaction extends BudgetTransaction {
  late final nameProperty = FieldProperty<String>(name: 'name').required();

  late final envelopeProperty = ReferenceFieldProperty<EnvelopeEntity>(name: 'envelope')..required();

  late final amountCentsProperty = FieldProperty<int>(name: 'amount').required();

  @override
  Property<List<String>> get abstractAffectedEnvelopesProperty => ListComputedProperty(
        name: BudgetTransaction.affectedEnvelopesField,
        computation: () => [envelopeProperty.value!],
      );

  @override
  List<Property> get properties => super.properties + [nameProperty, envelopeProperty, amountCentsProperty];
}

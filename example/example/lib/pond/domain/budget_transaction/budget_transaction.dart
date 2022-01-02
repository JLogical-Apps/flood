import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetTransaction extends ValueObject {
  static const budgetField = 'budget';
  late final budgetProperty = ReferenceFieldProperty<BudgetEntity>(name: budgetField).required();

  static const affectedEnvelopesField = 'affectedEnvelopes';
  late final affectedEnvelopesProperty = ReferenceFieldProperty<EnvelopeEntity>(name: affectedEnvelopesField)..required();

  @override
  List<Property> get properties => super.properties + [budgetProperty, affectedEnvelopesProperty];
}

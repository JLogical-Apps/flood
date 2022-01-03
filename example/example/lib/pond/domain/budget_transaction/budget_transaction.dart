import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class BudgetTransaction extends ValueObject {
  static const budgetField = 'budget';
  late final budgetProperty = ReferenceFieldProperty<BudgetEntity>(name: budgetField).required();

  Property<List<String>> get abstractAffectedEnvelopesProperty;

  static const affectedEnvelopesField = 'affectedEnvelopes';
  late final affectedEnvelopesProperty = abstractAffectedEnvelopesProperty;

  @override
  List<Property> get properties => super.properties + [budgetProperty, affectedEnvelopesProperty];
}

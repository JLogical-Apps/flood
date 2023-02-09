import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class Envelope extends ValueObject {
  late final nameProperty = field<String>(name: 'name').required();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  late final ruleProperty = field<EnvelopeRule>(name: 'rule');

  @override
  List<ValueObjectBehavior> get behaviors => [
        nameProperty,
        budgetProperty,
      ];
}

import 'package:example/features/budget/budget_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';
import 'package:meta/meta.dart';

abstract class BudgetTransaction extends ValueObject {
  static const affectedEnvelopesField = 'affectedEnvelopes';
  late final affectedEnvelopesProperty = computed<List<String>>(
    name: affectedEnvelopesField,
    computation: () => affectedEnvelopeIds,
  );

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  List<String> get affectedEnvelopeIds;

  @override
  @mustCallSuper
  List<ValueObjectBehavior> get behaviors => [affectedEnvelopesProperty, budgetProperty];
}

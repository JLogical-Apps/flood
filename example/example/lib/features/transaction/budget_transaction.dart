import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';
import 'package:meta/meta.dart';

abstract class BudgetTransaction extends ValueObject {
  static const envelopeField = 'envelope';
  late final envelopeProperty = reference<EnvelopeEntity>(name: envelopeField).required();

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  @override
  @mustCallSuper
  List<ValueObjectBehavior> get behaviors => [envelopeProperty, budgetProperty];
}

import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class BudgetTransaction extends ValueObject {
  late final envelopeProperty = reference<EnvelopeEntity>(name: 'envelope').required();
  late final budgetProperty = reference<BudgetEntity>(name: 'budget').required();

  @override
  @mustCallSuper
  List<ValueObjectBehavior> get behaviors => [envelopeProperty, budgetProperty];
}

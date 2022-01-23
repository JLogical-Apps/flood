import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget.dart';
import 'budget_entity.dart';

class BudgetRepository extends DefaultAdaptingRepository<BudgetEntity, Budget> {
  final Directory baseDirectory;

  String get collectionPath => 'budgets';

  BudgetRepository({required this.baseDirectory});

  @override
  BudgetEntity createEntity() {
    return BudgetEntity();
  }

  @override
  Budget createValueObject() {
    return Budget();
  }
}

import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';
import 'budget_transaction_entity.dart';

class FileBudgetTransactionRepository extends DefaultFileRepository<BudgetTransactionEntity, BudgetTransaction> {
  @override
  final Directory baseDirectory;

  FileBudgetTransactionRepository({required this.baseDirectory});

  @override
  BudgetTransactionEntity createEntity() {
    return BudgetTransactionEntity();
  }

  @override
  BudgetTransaction createValueObject() {
    return BudgetTransaction();
  }
}

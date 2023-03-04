import 'package:example/features/transaction/amount_transaction.dart';
import 'package:example/features/transaction/amount_transaction_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class BudgetTransactionRepository with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.memory()
      .forAbstractType<BudgetTransactionEntity, BudgetTransaction>(
        entityTypeName: 'BudgetTransactionEntity',
        valueObjectTypeName: 'BudgetTransaction',
      )
      .withImplementation<AmountTransactionEntity, AmountTransaction>(
        AmountTransactionEntity.new,
        AmountTransaction.new,
        entityTypeName: 'AmountTransactionEntity',
        valueObjectTypeName: 'AmountTransaction',
      );
}

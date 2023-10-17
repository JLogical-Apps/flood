import 'package:example_core/features/transaction/budget_transaction.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:example_core/features/transaction/envelope_transaction_entity.dart';
import 'package:example_core/features/transaction/income_transaction.dart';
import 'package:example_core/features/transaction/income_transaction_entity.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:example_core/features/transaction/transfer_transaction_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class BudgetTransactionRepository with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.forAbstractType<BudgetTransactionEntity, BudgetTransaction>(
    entityTypeName: 'BudgetTransactionEntity',
    valueObjectTypeName: 'BudgetTransaction',
  )
      .withImplementation<EnvelopeTransactionEntity, EnvelopeTransaction>(
        EnvelopeTransactionEntity.new,
        EnvelopeTransaction.new,
        entityTypeName: 'EnvelopeTransactionEntity',
        valueObjectTypeName: 'EnvelopeTransaction',
      )
      .withImplementation<IncomeTransactionEntity, IncomeTransaction>(
        IncomeTransactionEntity.new,
        IncomeTransaction.new,
        entityTypeName: 'IncomeTransactionEntity',
        valueObjectTypeName: 'IncomeTransaction',
      )
      .withImplementation<TransferTransactionEntity, TransferTransaction>(
        TransferTransactionEntity.new,
        TransferTransaction.new,
        entityTypeName: 'TransferTransactionEntity',
        valueObjectTypeName: 'TransferTransaction',
      )
      .adapting('transactions')
      .withSecurity(RepositorySecurity.authenticated());
}
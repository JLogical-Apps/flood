import 'package:example/pond/domain/budget_transaction/transfer_transaction.dart';
import 'package:example/pond/domain/budget_transaction/transfer_transaction_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';
import 'budget_transaction_entity.dart';
import 'envelope_transaction.dart';
import 'envelope_transaction_entity.dart';

class BudgetTransactionRepository
    extends DefaultAbstractAdaptingRepository<BudgetTransactionEntity, BudgetTransaction> {
  @override
  String get dataPath => 'transactions';

  @override
  String get unionTypeFieldName => 'runtimeType';

  @override
  String unionTypeConverter(String typeName) {
    if (typeName == '$EnvelopeTransactionEntity') {
      return 'envelope';
    } else if (typeName == '$TransferTransactionEntity') {
      return 'transfer';
    }

    return 'budgetTransaction';
  }

  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [
        ValueObjectRegistration<BudgetTransaction, BudgetTransaction?>.abstract(),
        ValueObjectRegistration<EnvelopeTransaction, EnvelopeTransaction?>(
          () => EnvelopeTransaction(),
          parents: {BudgetTransaction},
        ),
        ValueObjectRegistration<TransferTransaction, TransferTransaction?>(
          () => TransferTransaction(),
          parents: {BudgetTransaction},
        ),
      ];

  @override
  List<EntityRegistration> get entityRegistrations => [
        EntityRegistration<BudgetTransactionEntity, BudgetTransaction>.abstract(),
        EntityRegistration<EnvelopeTransactionEntity, EnvelopeTransaction>(() => EnvelopeTransactionEntity()),
        EntityRegistration<TransferTransactionEntity, TransferTransaction>(() => TransferTransactionEntity()),
      ];

  @override
  EntityRepository getFirestoreRepository() {
    return super.getFirestoreRepository().asSyncingRepository(localRepository: getFileRepository());
  }
}

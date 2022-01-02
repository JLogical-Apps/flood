import 'dart:io';

import 'package:example/pond/domain/budget_transaction/transfer_transaction.dart';
import 'package:example/pond/domain/budget_transaction/transfer_transaction_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'budget_transaction.dart';
import 'budget_transaction_entity.dart';
import 'envelope_transaction.dart';
import 'envelope_transaction_entity.dart';

class FileBudgetTransactionRepository
    extends DefaultAbstractFileRepository<BudgetTransactionEntity, BudgetTransaction> {
  @override
  final Directory baseDirectory;

  FileBudgetTransactionRepository({required this.baseDirectory});

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
}

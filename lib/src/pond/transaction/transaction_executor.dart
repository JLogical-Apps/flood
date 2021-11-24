import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/utils/synchronizable.dart';

import 'transaction.dart';

abstract class TransactionExecutor extends Synchronizable<Transaction> {
  EntityRepository get repository;

  Future<void> commit();

  Future<void> revert();
}

extension Default on TransactionExecutor {
  Future<void> executeTransaction(Transaction transaction) async {
    await lock(transaction);
    try {
      await transaction.execute(repository);
    } catch (e) {
      await revert();
    } finally {
      unlock(transaction);
    }
  }
}

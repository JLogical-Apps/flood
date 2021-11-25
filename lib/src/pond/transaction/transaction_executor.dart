import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/utils/synchronizable.dart';

import 'transaction.dart';

abstract class TransactionExecutor extends Synchronizable<Transaction> {
  EntityRepository get repository;

  Future<void> commit();

  Future<void> revert();
}

extension Default on TransactionExecutor {
  Future<V> executeTransaction<V>(Transaction<V> transaction) async {
    await lock(transaction);
    try {
      final value = await transaction.onExecute(repository);
      await commit();
      return value;
    } catch (e) {
      await revert();
      throw e;
    } finally {
      unlock(transaction);
    }
  }
}

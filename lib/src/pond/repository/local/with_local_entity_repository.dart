import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

import '../entity_repository.dart';
import '../with_transactions_and_cache_entity_repository.dart';

mixin WithLocalEntityRepository on EntityRepository implements WithTransactionsAndCacheEntityRepository {
  @override
  Future<void> save(Entity entity, {Transaction? transaction}) async {
    // Do nothing since cache takes care of it.
  }

  @override
  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false}) async {
    // Do nothing since cache takes care of it.
    return null;
  }

  @override
  Future<void> delete(String id, {Transaction? transaction}) async {
    // Do nothing since cache takes care of it.
  }

  Future<void> commitTransactionChanges(TransactionPendingChanges changes) async {
    // Do nothing since cache takes care of it.
  }

  QueryExecutor getQueryExecutor({Transaction? transaction}) {
    return LocalQueryExecutor(stateById: getTransactionStateById(transaction: transaction));
  }
}

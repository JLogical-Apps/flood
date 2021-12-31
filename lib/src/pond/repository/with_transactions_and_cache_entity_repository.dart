import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/cache/cache.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:rxdart/rxdart.dart';

mixin WithTransactionsAndCacheEntityRepository on EntityRepository {
  final Cache<String, State> _stateByIdCache = Cache();

  TransactionPendingChanges? _pendingTransactionChange;

  QueryExecutor getQueryExecutor({Transaction? transaction});

  @override
  Future<void> save(Entity entity, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));

    if (transaction != null) {
      _pendingTransactionChange!.stateChangesById[id] = entity.state;
    } else {
      await entity.beforeSave();
      await super.save(entity, transaction: null);
      _stateByIdCache.save(id, entity.state);
      await entity.afterSave();
    }
  }

  @override
  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false}) async {
    _startTransactionIfNew(transaction);

    State? state;
    if (transaction != null) {
      final isDeletedInTransaction = _pendingTransactionChange!.stateIdDeletes.contains(id);
      if (isDeletedInTransaction) {
        return null;
      }

      state = _pendingTransactionChange!.stateChangesById[id];
    }

    if (!withoutCache) {
      state ??= _stateByIdCache.get(id);
    }

    if (state == null) {
      final uncachedState = (await super.getOrNull(id, transaction: transaction))?.state;
      if (uncachedState != null) {
        _stateByIdCache.save(id, uncachedState);
        state = uncachedState;
      }
    }

    return state.mapIfNonNull((state) => Entity.fromStateOrNull(state));
  }

  ValueStream<FutureValue<Entity>> getX(String id) {
    return _stateByIdCache.getX(id).mapWithValue((state) => state != null
        ? FutureValue.loaded(value: Entity.fromState(state))
        : FutureValue.error(error: 'No state found with id [$id]'));
  }

  @override
  Future<void> delete(Entity entity, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    final id = entity.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));

    await entity.beforeDelete();

    if (transaction != null) {
      _pendingTransactionChange!.stateIdDeletes.add(id);
    } else {
      await super.delete(entity, transaction: transaction);
      _stateByIdCache.remove(id);
      await Future.sync(() {});
    }
  }

  @override
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest) {
    return _stateByIdCache.valueByKeyX.asyncMapWithValue((stateById) => executeQuery(queryRequest));
  }

  @override
  Future<T> executeQuery<R extends Record, T>(
    AbstractQueryRequest<R, T> queryRequest, {
    Transaction? transaction,
  }) async {
    _startTransactionIfNew(transaction);
    return getQueryExecutor(transaction: transaction).executeQuery(queryRequest);
  }

  Map<String, State> getTransactionStateById({Transaction? transaction}) {
    if (transaction == null) {
      return _stateByIdCache.valueByKey;
    } else if (transaction == _currentTransaction) {
      return _getCommittedStateById();
    }

    throw Exception('Unable to get state by id for transaction $transaction');
  }

  Future<void> commitTransactionChanges(TransactionPendingChanges changes);

  @override
  Future<void> commit() async {
    final pendingTransactionChange =
        _pendingTransactionChange ?? (throw Exception('Can only commit if a budget_transaction has started!'));

    await commitTransactionChanges(pendingTransactionChange);

    final newStateById = _stateByIdCache.valueByKey.copy();

    newStateById.addAll(pendingTransactionChange.stateChangesById);
    newStateById.removeWhere((id, state) => pendingTransactionChange.stateIdDeletes.contains(id));

    _stateByIdCache.valueByKey = newStateById;
  }

  @override
  Future<void> revert() async {
    _pendingTransactionChange = null;
  }

  Transaction? get _currentTransaction => _pendingTransactionChange?.transaction;

  void _startTransactionIfNew(Transaction? transaction) {
    if (transaction != null && transaction != _currentTransaction) {
      _pendingTransactionChange = TransactionPendingChanges(transaction: transaction);
    }
  }

  Map<String, State> _getCommittedStateById() {
    final pendingTransactionChange =
        _pendingTransactionChange ?? (throw Exception('Can only commit if a budget_transaction has started!'));

    final committedStateById = _stateByIdCache.valueByKey.copy();
    committedStateById.addAll(pendingTransactionChange.stateChangesById);
    committedStateById.removeWhere((id, state) => pendingTransactionChange.stateIdDeletes.contains(id));
    return committedStateById;
  }
}

class TransactionPendingChanges {
  final Transaction transaction;
  final Map<String, State> stateChangesById;
  final Set<String> stateIdDeletes;

  TransactionPendingChanges({required this.transaction})
      : stateChangesById = {},
        stateIdDeletes = {};
}

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/cache/cache.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';
import 'package:rxdart/rxdart.dart';

mixin WithLocalEntityRepository on EntityRepository {
  final Cache<String, State> _stateByIdCache = Cache();

  _TransactionPendingChanges? _pendingTransactionChange;

  @override
  Future<Entity?> save(Entity entity, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));

    if (transaction != null) {
      _pendingTransactionChange!.stateChangesById[id] = entity.state;
    } else {
      _stateByIdCache.save(id, entity.state);
    }
  }

  @override
  Future<Entity?> getOrNull(String id, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    State? state;
    if (transaction != null) {
      final isDeletedInTransaction = _pendingTransactionChange!.stateIdDeletes.contains(id);
      if (isDeletedInTransaction) {
        return null;
      }

      state = _pendingTransactionChange!.stateChangesById[id];
    }

    state ??= _stateByIdCache.get(id);

    return state.mapIfNonNull((state) => Entity.fromStateOrNull(state));
  }

  ValueStream<FutureValue<Entity>> getX(String id) {
    return _stateByIdCache.getX(id).mapWithValue((state) => state != null
        ? FutureValue.loaded(value: Entity.fromState(state))
        : FutureValue.error(error: 'No state found with id [$id]'));
  }

  @override
  Future<void> delete(String id, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    if (transaction != null) {
      _pendingTransactionChange!.stateIdDeletes.add(id);
    } else {
      _stateByIdCache.remove(id);
    }
  }

  @override
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest) {
    return _stateByIdCache.valueByKeyX.switchMapWithValue((stateById) => executeQuery(queryRequest).asValueStream());
  }

  @override
  Future<T> executeQuery<R extends Record, T>(
    AbstractQueryRequest<R, T> queryRequest, {
    Transaction? transaction,
  }) async {
    _startTransactionIfNew(transaction);

    late Map<String, State> stateById;
    if (transaction == null) {
      stateById = _stateByIdCache.valueByKey;
    } else if (transaction == _currentTransaction) {
      stateById = _getCommittedStateById();
    }

    return LocalQueryExecutor(stateById: stateById).executeQuery(queryRequest);
  }

  @override
  Future<void> commit() async {
    final pendingTransactionChange =
        _pendingTransactionChange ?? (throw Exception('Can only commit if a budget_transaction has started!'));

    var newStateById = _stateByIdCache.valueByKey.copy();

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
      _pendingTransactionChange = _TransactionPendingChanges(transaction: transaction);
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

class _TransactionPendingChanges {
  final Transaction transaction;
  final Map<String, State> stateChangesById;
  final Set<String> stateIdDeletes;

  _TransactionPendingChanges({required this.transaction})
      : stateChangesById = {},
        stateIdDeletes = {};
}

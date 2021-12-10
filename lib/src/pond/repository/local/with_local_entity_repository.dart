import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';
import 'package:rxdart/rxdart.dart';

mixin WithLocalEntityRepository<E extends Entity> on EntityRepository<E> {
  BehaviorSubject<Map<String, State>> _stateByIdX = BehaviorSubject.seeded({});

  _TransactionPendingChanges? _pendingTransactionChange;

  Map<String, State> get _stateById => _stateByIdX.value;

  set _stateById(Map<String, State> value) => _stateByIdX.value = value;

  @override
  Future<E?> save(E entity, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));

    if (transaction != null) {
      _pendingTransactionChange!.stateChangesById[id] = entity.state;
    } else {
      _stateById = _stateById.copy()..set(id, entity.state);
    }
  }

  @override
  Future<E?> getOrNull(String id, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    State? state;
    if (transaction != null) {
      final isDeletedInTransaction = _pendingTransactionChange!.stateIdDeletes.contains(id);
      if (isDeletedInTransaction) {
        return null;
      }

      state = _pendingTransactionChange!.stateChangesById[id];
    }

    state ??= _stateById[id];

    return state.mapIfNonNull((state) => Entity.fromStateOrNull<E>(state));
  }

  ValueStream<FutureValue<E>>? getXOrNull(String id) {
    final state = _stateById[id];
    if (state == null) {
      return null;
    }

    return _stateByIdX.mapWithValue((stateById) {
      return stateById[id].mapIfNonNull((state) => FutureValue.loaded(value: Entity.fromState<E>(state))) ??
          FutureValue.error(error: 'No state found with id [$id]');
    });
  }

  @override
  Future<void> delete(String id, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    if (transaction != null) {
      _pendingTransactionChange!.stateIdDeletes.add(id);
    } else {
      _stateById = _stateById.copy()..remove(id);
    }
  }

  @override
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest) {
    return _stateByIdX.switchMapWithValue((stateById) => executeQuery(queryRequest).asValueStream());
  }

  @override
  Future<T> executeQuery<R extends Record, T>(
    AbstractQueryRequest<R, T> queryRequest, {
    Transaction? transaction,
  }) async {
    _startTransactionIfNew(transaction);

    late Map<String, State> stateById;
    if (transaction == null) {
      stateById = _stateById;
    } else if (transaction == _currentTransaction) {
      stateById = _getCommittedStateById();
    }

    return LocalQueryExecutor(stateById: stateById).executeQuery(queryRequest);
  }

  @override
  Future<void> commit() async {
    final pendingTransactionChange =
        _pendingTransactionChange ?? (throw Exception('Can only commit if a transaction has started!'));

    var newStateById = _stateById.copy();

    newStateById.addAll(pendingTransactionChange.stateChangesById);
    newStateById.removeWhere((id, state) => pendingTransactionChange.stateIdDeletes.contains(id));

    _stateById = newStateById;
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
        _pendingTransactionChange ?? (throw Exception('Can only commit if a transaction has started!'));

    final committedStateById = {..._stateById};
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

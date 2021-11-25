import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';

mixin WithLocalEntityRepository<E extends Entity> on EntityRepository<E> {
  Map<String, State> _stateById = Map();

  _TransactionPendingChanges? _pendingTransactionChange;

  @override
  Future<E?> save(E entity, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));

    if (transaction != null) {
      _pendingTransactionChange!.stateChangesById[id] = entity.state;
    } else {
      _stateById[id] = entity.state;
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

  @override
  Future<void> delete(String id, {Transaction? transaction}) async {
    _startTransactionIfNew(transaction);

    if (transaction != null) {
      _pendingTransactionChange!.stateIdDeletes.add(id);
    } else {
      _stateById.remove(id);
    }
  }

  @override
  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest, {Transaction? transaction}) async {
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
    _stateById = _getCommittedStateById();
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

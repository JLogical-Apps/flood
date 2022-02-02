import 'dart:async';

import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/patterns/cache/cache.dart';
import 'package:jlogical_utils/src/pond/modules/logging/default_logging_module.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:jlogical_utils/src/utils/util.dart';
import 'package:rxdart/rxdart.dart';

import 'entity_repository.dart';

mixin WithTransactionsAndCacheEntityRepository on EntityRepository {
  final Cache<String, State> _stateByIdCache = Cache();

  final Map<String, Completer<State?>> _completerById = {};

  TransactionPendingChanges? _pendingTransactionChange;

  QueryExecutor getQueryExecutor({Transaction? transaction});

  void saveToCache(Entity entity) {
    _stateByIdCache.save(entity.id!, entity.state);
  }

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

    state ??= await _getOrNullFromSourceRepository(id, transaction: transaction);

    return state.mapIfNonNull((state) => Entity.fromStateOrNull(state));
  }

  Future<State?> _getOrNullFromSourceRepository(String id, {Transaction? transaction}) async {
    var completer = _completerById[id];
    if (completer != null) {
      return await completer.future;
    }

    completer = Completer<State?>();
    _completerById[id] = completer;

    log('Getting source data for $id from ${runtimeType.toString()}');
    final sourceState = (await super.getOrNull(id, transaction: transaction))?.state;

    completer.complete(sourceState);
    _completerById.remove(id);

    if (sourceState != null) {
      _stateByIdCache.save(id, sourceState);
    }

    return sourceState;
  }

  ValueStream<FutureValue<Entity?>> getXOrNull(String id) {
    if (!_stateByIdCache.exists(id)) {
      get(id, withoutCache: true);
    }
    return _stateByIdCache.getX(id).mapWithValue(
          (state) => state == null ? FutureValue.initial() : FutureValue.loaded(value: Entity.fromState(state)),
        );
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
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return _stateByIdCache.valueByKeyX.asyncMapWithValue((stateById) => executeQuery(queryRequest));
  }

  @override
  Future<T> executeQuery<R extends Record, T>(
    QueryRequest<R, T> queryRequest, {
    Transaction? transaction,
  }) async {
    _startTransactionIfNew(transaction);
    if (queryRequest.isWithoutCache()) {
      return getQueryExecutor(transaction: transaction).executeQuery(queryRequest);
    } else {
      return LocalQueryExecutor(stateById: _stateByIdCache.valueByKey).executeQuery(queryRequest);
    }
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

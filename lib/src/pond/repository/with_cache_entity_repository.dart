import 'dart:async';

import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/patterns/cache/cache.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:jlogical_utils/src/utils/util.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../query/request/first_or_null_query_request.dart';
import 'entity_repository.dart';

mixin WithCacheEntityRepository on EntityRepository {
  final Cache<String, State> _stateByIdCache = Cache();
  final Lock _saveLock = Lock(reentrant: true);

  final Map<String, Completer<State?>> _getCompleterById = {};
  final Map<QueryRequest, Completer<dynamic>> _queryCompleterByQueryRequest = {};

  QueryExecutor getQueryExecutor();

  Future<void> onWithoutCacheQueryExecuted(QueryRequest queryRequest) async {}

  void saveToCache(Entity entity) {
    _stateByIdCache.save(entity.id!, entity.state);
  }

  @override
  Future<void> save(Entity entity) async {
    final id = entity.id ?? (throw Exception('Cannot save entity that has a null id!'));

    await entity.beforeSave();
    _stateByIdCache.save(id, entity.state);
    await _saveLock.synchronized(() => super.save(entity));
    await entity.afterSave();
  }

  @override
  Future<Entity?> getOrNull(String id, {bool withoutCache: false}) async {
    State? state;
    bool fromSource = false;

    if (!withoutCache) {
      state ??= _stateByIdCache.get(id);
    }

    if (state == null) {
      state ??= await _getOrNullFromSourceRepository(id);
      if (state != null) {
        fromSource = true;
      }
    }

    final entity = state.mapIfNonNull((state) => Entity.fromStateOrNull(state));

    if (fromSource) {
      await entity?.onInitialize();
    }

    return entity;
  }

  Future<State?> _getOrNullFromSourceRepository(String id) async {
    var completer = _getCompleterById[id];
    if (completer != null) {
      return await completer.future;
    }

    completer = Completer<State?>();
    _getCompleterById[id] = completer;

    final sourceState = (await super.getOrNull(id))?.state;

    completer.complete(sourceState);
    _getCompleterById.remove(id);

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
  Future<void> delete(Entity entity) async {
    final id = entity.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));

    await entity.beforeDelete();

    await super.delete(entity);
    _stateByIdCache.remove(id);
    await Future.sync(() {});
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    if (queryRequest.isWithoutCache()) {
      throw Exception('Cannot run `useQueryX()` with a `withoutCache()` query!');
    }

    FutureValue<T> initialValue;
    if (hasBeenRunBefore(queryRequest) || _isCachedFirstOrNull(queryRequest)) {
      initialValue = FutureValue.loaded(value: executeQuerySync(queryRequest));
    } else {
      initialValue = FutureValue.initial();

      executeQuery(queryRequest.withoutCache()); // Run the cacheless query in order to fetch latest data.
    }

    return _stateByIdCache.valueByKeyX.asyncMapWithValue(
      (stateById) => executeQuery(queryRequest),
      initialValue: initialValue,
    );
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    if (!queryRequest.isWithoutCache() && !hasBeenRunBefore(queryRequest) && !_isCachedFirstOrNull(queryRequest)) {
      queryRequest = queryRequest.withoutCache();
    }

    T result;
    if (queryRequest.isWithoutCache()) {
      var completer = _queryCompleterByQueryRequest[queryRequest];
      if (completer != null) {
        return await completer.future;
      }

      completer = Completer();
      _queryCompleterByQueryRequest[queryRequest] = completer;

      await onWithoutCacheQueryExecuted(queryRequest);
      logMessage('Using without-cache query [$queryRequest]');
      result = await getQueryExecutor().executeQuery(queryRequest);
      markHasBeenRun(queryRequest);

      completer.complete(result);
      _queryCompleterByQueryRequest.remove(queryRequest);
    } else {
      result = executeQuerySync(queryRequest);
    }

    return result;
  }

  T executeQuerySync<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return LocalQueryExecutor(stateById: _stateByIdCache.valueByKey).executeQuerySync(queryRequest);
  }

  Map<String, State> getStateById() {
    return _stateByIdCache.valueByKey;
  }

  bool _isCachedFirstOrNull(QueryRequest queryRequest) {
    if (queryRequest is FirstOrNullQueryRequest && !queryRequest.orderMatters) {
      final result = executeQuerySync(queryRequest);
      return result != null;
    }

    return false;
  }
}

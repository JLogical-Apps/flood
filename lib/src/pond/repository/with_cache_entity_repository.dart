import 'dart:async';

import 'package:jlogical_utils/src/pond/modules/logging/default_logging_module.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../../model/export_core.dart';
import '../../patterns/export_core.dart';
import '../query/request/first_or_null_query_request.dart';
import '../query/request/result/query_pagination_result_controller.dart';
import 'entity_repository.dart';

mixin WithCacheEntityRepository on EntityRepository {
  final Cache<String, State> _stateByIdCache = Cache();
  final Lock _saveLock = Lock(reentrant: true);

  final Map<QueryRequest, Completer<dynamic>> _queryCompleterByQueryRequest = {};
  final Map<Query, QueryPaginationResultController> _sourcePaginationResultControllerByQuery = {};

  String get repositoryName => runtimeType.toString();

  QueryExecutor getQueryExecutor({
    required void onPaginationControllerCreated(Query query, QueryPaginationResultController controller),
  });

  Future<void> onWithoutCacheQueryExecuted(QueryRequest queryRequest) async {}

  void saveToCache(Entity entity) {
    _stateByIdCache.save(entity.id!, entity.state);
  }

  @override
  Future<void> saveState(State state) async {
    final id = state.id ?? (throw Exception('Cannot save entity that has a null id!'));

    log('$repositoryName: Saving id [$id] with [$state]');

    _stateByIdCache.save(id, state);
    await _saveLock.synchronized(() => super.saveState(state));
  }

  @override
  Future<void> deleteState(State state) async {
    final id = state.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));

    log('$repositoryName: Deleting id [$id] with [$state]');

    await super.deleteState(state);

    _stateByIdCache.remove(id);
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
      log('Using without-cache query [$queryRequest]');
      result = await getQueryExecutor(
        onPaginationControllerCreated: (query, paginationController) =>
            _sourcePaginationResultControllerByQuery[query] = paginationController,
      ).executeQuery(queryRequest);
      markHasBeenRun(queryRequest);

      completer.complete(result);
      _queryCompleterByQueryRequest.remove(queryRequest);

      var sourceQueryRequest = queryRequest;
      if (sourceQueryRequest is WithoutCacheQueryRequest<R, T>) {
        sourceQueryRequest = sourceQueryRequest.queryRequest;
      }

      if (sourceQueryRequest is PaginateQueryRequest) {
        result = executeQuerySync(sourceQueryRequest);
      }
    } else {
      result = executeQuerySync(queryRequest);
    }

    return result;
  }

  T executeQuerySync<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return LocalQueryExecutor(
      stateById: _stateByIdCache.valueByKey,
      sourcePaginationResultControllerByQueryGetter: (query) => _sourcePaginationResultControllerByQuery[query],
    ).executeQuerySync(queryRequest);
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

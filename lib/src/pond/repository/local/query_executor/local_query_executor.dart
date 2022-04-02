import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/with_sync_resolver_query_executor.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_sync_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_order_by_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_without_cache_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/abstract_local_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_all_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_all_raw_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_paginate_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../query/request/result/query_pagination_result_controller.dart';
import '../../../record/entity.dart';
import 'reducer/query/local_from_query_reducer.dart';
import 'reducer/request/local_first_query_request_reducer.dart';
import 'reducer/request/local_without_cache_query_request_reducer.dart';

class LocalQueryExecutor with WithSyncResolverQueryExecutor<Iterable<State>> implements QueryExecutor {
  final Map<String, State> stateById;

  final Future<void> Function(Entity entity) onEntityInflated;

  final QueryPaginationResultController? Function(Query query)? sourcePaginationResultControllerByQueryGetter;

  const LocalQueryExecutor({
    required this.stateById,
    this.onEntityInflated: _defaultOnEntityInflated,
    this.sourcePaginationResultControllerByQueryGetter,
  });

  List<AbstractSyncQueryReducer<Query, Iterable<State>>> getSyncQueryReducers(QueryRequest queryRequest) => [
        LocalFromQueryReducer(stateById: stateById),
        LocalWhereQueryReducer(),
        LocalOrderByQueryReducer(),
        LocalWithoutCacheQueryReducer(),
      ];

  List<AbstractLocalQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>
      getSyncQueryRequestReducers<R extends Record>() => [
            LocalAllQueryRequestReducer<R>(onEntityInflated: onEntityInflated),
            LocalAllRawQueryRequestReducer<R>(),
            LocalFirstOrNullQueryRequestReducer<R>(onEntityInflated: onEntityInflated),
            LocalPaginateQueryRequestReducer<R>(
              onEntityInflated: onEntityInflated,
              sourcePaginationResultControllerByQueryGetter: sourcePaginationResultControllerByQueryGetter,
            ),
            LocalWithoutCacheQueryRequestReducer<R>(
                queryRequestReducerResolverGetter: () => getQueryRequestReducerResolver<R>()),
          ];

  static Future<void> _defaultOnEntityInflated(Entity entity) async {}
}

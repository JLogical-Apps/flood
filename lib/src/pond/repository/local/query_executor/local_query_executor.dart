import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/with_resolver_query_executor.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_order_by_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/query/local_without_cache_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/abstract_local_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_all_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/request/local_paginate_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'reducer/query/local_from_query_reducer.dart';
import 'reducer/request/local_first_query_request_reducer.dart';
import 'reducer/request/local_without_cache_query_request_reducer.dart';

class LocalQueryExecutor with WithResolverQueryExecutor<Iterable<Record>> implements QueryExecutor {
  final Map<String, State> stateById;

  const LocalQueryExecutor({required this.stateById});

  List<AbstractQueryReducer<Query, Iterable<Record>>> getQueryReducers(QueryRequest queryRequest) => [
        LocalFromQueryReducer(stateById: stateById),
        LocalWhereQueryReducer(),
        LocalOrderByQueryReducer(),
        LocalWithoutCacheQueryReducer(),
      ];

  List<AbstractLocalQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducers<R extends Record>() => [
            LocalAllQueryRequestReducer<R>(),
            LocalFirstOrNullQueryRequestReducer<R>(),
            LocalPaginateQueryRequestReducer<R>(),
            LocalWithoutCacheQueryRequestReducer<R>(
                queryRequestReducerResolverGetter: () => getQueryRequestReducerResolver<R>()),
          ];
}

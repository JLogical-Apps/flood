import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/wrapper_resolver.dart';
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

  Resolver<Query, AbstractQueryReducer<Query, Iterable<Record>>> getQueryReducerResolver(QueryRequest queryRequest) =>
      WrapperResolver([
        LocalFromQueryReducer(stateById: stateById),
        LocalWhereQueryReducer(),
        LocalOrderByQueryReducer(),
        LocalWithoutCacheQueryReducer(),
      ]);

  Resolver<QueryRequest<R, dynamic>, AbstractLocalQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducerResolver<R extends Record>() => WrapperResolver<QueryRequest<R, dynamic>,
              AbstractLocalQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>([
            LocalAllQueryRequestReducer<R>(),
            LocalFirstOrNullQueryRequestReducer<R>(),
            LocalPaginateQueryRequestReducer<R>(),
            LocalWithoutCacheQueryRequestReducer<R>(
                queryRequestReducerResolverGetter: () => getQueryRequestReducerResolver()),
          ]);
}

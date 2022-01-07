import 'dart:io';

import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/with_resolver_query_executor.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/query/file_order_by_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/query/file_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/query/file_without_cache_query_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'reducer/query/file_from_query_reducer.dart';
import 'reducer/request/abstract_file_query_request_reducer.dart';
import 'reducer/request/file_all_query_request_reducer.dart';
import 'reducer/request/file_first_query_request_reducer.dart';
import 'reducer/request/file_paginate_query_request_reducer.dart';
import 'reducer/request/file_without_cache_query_request_reducer.dart';

class FileQueryExecutor with WithResolverQueryExecutor<Iterable<Record>> implements QueryExecutor {
  final Directory baseDirectory;
  final Future<State> Function(String id, bool withoutCache) stateGetter;

  FileQueryExecutor({required this.baseDirectory, required this.stateGetter});

  Resolver<Query, AbstractQueryReducer<Query, Iterable<Record>>> getQueryReducerResolver(QueryRequest queryRequest) =>
      WrapperResolver([
        FileFromQueryReducer(
            baseDirectory: baseDirectory, stateGetter: (id) => stateGetter(id, queryRequest.isWithoutCache())),
        FileWhereQueryReducer(),
        FileOrderByQueryReducer(),
        FileWithoutCacheQueryReducer(),
      ]);

  Resolver<QueryRequest<R, dynamic>, AbstractFileQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducerResolver<R extends Record>() => WrapperResolver<QueryRequest<R, dynamic>,
              AbstractFileQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>([
            FileAllQueryRequestReducer<R>(),
            FileFirstOrNullQueryRequestReducer<R>(),
            FilePaginateQueryRequestReducer<R>(),
            FileWithoutCacheQueryRequestReducer<R>(
                queryRequestReducerResolverGetter: () => getQueryRequestReducerResolver()),
          ]);
}

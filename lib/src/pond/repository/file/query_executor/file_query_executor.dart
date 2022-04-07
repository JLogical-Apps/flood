import 'dart:io';

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

import '../../../query/reducer/entity_inflater.dart';
import '../../../query/request/result/query_pagination_result_controller.dart';
import 'reducer/query/file_from_query_reducer.dart';
import 'reducer/request/abstract_file_query_request_reducer.dart';
import 'reducer/request/file_all_query_request_reducer.dart';
import 'reducer/request/file_all_raw_query_request_reducer.dart';
import 'reducer/request/file_first_query_request_reducer.dart';
import 'reducer/request/file_paginate_query_request_reducer.dart';
import 'reducer/request/file_without_cache_query_request_reducer.dart';

class FileQueryExecutor with WithResolverQueryExecutor<Iterable<State>> implements QueryExecutor {
  final Directory baseDirectory;
  final Future<State> Function(String id) stateGetter;
  final EntityInflater entityInflater;
  final void Function(Query query, QueryPaginationResultController controller) onPaginationControllerCreated;

  FileQueryExecutor({
    required this.baseDirectory,
    required this.stateGetter,
    required this.entityInflater,
    required this.onPaginationControllerCreated,
  });

  List<AbstractQueryReducer<Query, Iterable<State>>> getQueryReducers(QueryRequest queryRequest) => [
        FileFromQueryReducer(baseDirectory: baseDirectory, stateGetter: (id) => stateGetter(id)),
        FileWhereQueryReducer(),
        FileOrderByQueryReducer(),
        FileWithoutCacheQueryReducer(),
      ];

  List<AbstractFileQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducers<R extends Record>() => [
            FileAllQueryRequestReducer<R>(entityInflater: entityInflater),
            FileAllRawQueryRequestReducer<R>(),
            FileFirstOrNullQueryRequestReducer<R>(entityInflater: entityInflater),
            FilePaginateQueryRequestReducer<R>(
              entityInflater: entityInflater,
              onPaginationControllerCreated: onPaginationControllerCreated,
            ),
            FileWithoutCacheQueryRequestReducer<R>(
              queryRequestReducerResolverGetter: () => getQueryRequestReducerResolver(),
            ),
          ];
}

import 'dart:io';

import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/query/file_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

import 'reducer/query/file_from_query_reducer.dart';
import 'reducer/request/abstract_file_query_request_reducer.dart';
import 'reducer/request/file_all_query_request_reducer.dart';
import 'reducer/request/file_first_query_request_reducer.dart';
import 'reducer/request/file_paginate_query_request_reducer.dart';

class FileQueryExecutor implements QueryExecutor {
  final Directory baseDirectory;
  final Future<State> Function(String id) stateGetter;

  FileQueryExecutor({required this.baseDirectory, required this.stateGetter});

  Resolver<Query, AbstractQueryReducer<Query, Iterable<Record>>> getQueryReducerResolver() => WrapperResolver([
        FileFromQueryReducer(baseDirectory: baseDirectory, stateGetter: stateGetter),
        FileWhereQueryReducer(),
      ]);

  Resolver<AbstractQueryRequest<R, dynamic>,
          AbstractFileQueryRequestReducer<AbstractQueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducerResolver<R extends Record>() => WrapperResolver<AbstractQueryRequest<R, dynamic>,
              AbstractFileQueryRequestReducer<AbstractQueryRequest<R, dynamic>, R, dynamic>>([
            FileAllQueryRequestReducer<R>(),
            FileFirstOrNullQueryRequestReducer<R>(),
            FilePaginateQueryRequestReducer<R>(),
          ]);

  Future<T> executeQuery<R extends Record, T>(
    AbstractQueryRequest<R, T> queryRequest, {
    Transaction? transaction,
  }) async {
    final queryChain = queryRequest.query.getQueryChain();

    // [accumulation] represents all the records that match the query.
    Iterable<Record>? accumulation;
    for (final query in queryChain) {
      final queryReducer = getQueryReducerResolver().resolve(query);
      accumulation = await queryReducer.reduce(accumulation: accumulation, query: query);
    }

    final _accumulation = accumulation ??
        (throw Exception(
            'No aggregate for the query request $queryRequest has been established. This probably means the query request doesn\'t have a parent query.'));

    final accumulationList = _accumulation.cast<R>().toList();

    final queryRequestReducer = getQueryRequestReducerResolver<R>().resolve(queryRequest);
    final output = queryRequestReducer.reduce(accumulation: accumulationList, queryRequest: queryRequest);

    return output;
  }
}

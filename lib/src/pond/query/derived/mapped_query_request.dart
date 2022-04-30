import 'dart:async';

import 'package:jlogical_utils/src/pond/query/derived/derived_query_request.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/future_value.dart';
import '../../record/record.dart';
import '../executor/query_executor.dart';
import '../executor/query_executor_x.dart';
import '../query.dart';
import '../request/query_request.dart';

class MappedQueryRequest<R extends Record, T, S> extends DerivedQueryRequest<R, S> {
  final QueryRequest<R, T> queryRequest;

  final FutureOr<S> Function(T result) mapper;

  MappedQueryRequest({required this.queryRequest, required this.mapper});

  @override
  Query<R> get query => queryRequest.query;

  @override
  Future<S> deriveQueryResult(QueryExecutor queryExecutor) async {
    final result = await queryExecutor.executeQuery(queryRequest);
    return await mapper(result);
  }

  @override
  ValueStream<FutureValue<S>> deriveQueryResultX(QueryExecutorX queryExecutorX) {
    return queryExecutorX
        .executeQueryX(queryRequest)
        .asyncMapWithValue((result) => result.mapIfPresent((result) => mapper(result)).get());
  }

  @override
  String toString() {
    return '$queryRequest | mapped by ($mapper)';
  }
}

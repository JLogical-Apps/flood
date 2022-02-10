import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:rxdart/rxdart.dart';

import '../derived/derived_query_request.dart';
import '../request/without_cache_query_request.dart';

abstract class QueryExecutorX extends QueryExecutor {
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest);
}

extension QueryExecutorXExtensions on QueryExecutorX {
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    DerivedQueryRequest<R, T>? derivedQueryRequest;

    if (queryRequest is DerivedQueryRequest<R, T>) {
      derivedQueryRequest = queryRequest;
    }

    if (queryRequest is WithoutCacheQueryRequest<R, T> && queryRequest.queryRequest is DerivedQueryRequest<R, T>) {
      derivedQueryRequest = queryRequest.queryRequest as DerivedQueryRequest<R, T>;
    }

    if (derivedQueryRequest != null) {
      return derivedQueryRequest.deriveQueryResultX(this);
    }

    return onExecuteQueryX(queryRequest);
  }
}

import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import '../derived/derived_query_request.dart';

abstract class QueryExecutor {
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest);
}

extension QueryExecutorExtensions on QueryExecutor {
  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    DerivedQueryRequest<R, T>? derivedQueryRequest;

    if (queryRequest is DerivedQueryRequest<R, T>) {
      derivedQueryRequest = queryRequest;
    }

    if (queryRequest is WithoutCacheQueryRequest<R, T> && queryRequest.queryRequest is DerivedQueryRequest<R, T>) {
      derivedQueryRequest = queryRequest.queryRequest as DerivedQueryRequest<R, T>;
    }

    if (derivedQueryRequest != null) {
      return await derivedQueryRequest.deriveQueryResult(this);
    }

    return await onExecuteQuery(queryRequest);
  }
}

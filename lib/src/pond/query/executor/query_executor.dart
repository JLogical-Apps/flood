import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

import '../derived/derived_query_request.dart';

abstract class QueryExecutor {
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {Transaction? transaction});
}

extension QueryExecutorExtensions on QueryExecutor {
  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {Transaction? transaction}) async {
    if (queryRequest is DerivedQueryRequest<R, T>) {
      return await queryRequest.deriveQueryResult(this);
    }

    return await onExecuteQuery(queryRequest);
  }
}

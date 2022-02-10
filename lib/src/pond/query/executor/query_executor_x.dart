import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:rxdart/rxdart.dart';

import '../derived/derived_query_request.dart';

abstract class QueryExecutorX extends QueryExecutor {
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest);
}

extension QueryExecutorXExtensions on QueryExecutorX {
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    if (queryRequest is DerivedQueryRequest<R, T>) {
      return queryRequest.deriveQueryResultX(this);
    }

    return onExecuteQueryX(queryRequest);
  }
}

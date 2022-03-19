import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:rxdart/rxdart.dart';

import '../../record/record.dart';
import '../request/query_request.dart';

abstract class DerivedQueryRequest<R extends Record, T> extends QueryRequest<R, T> {
  Future<T> deriveQueryResult(QueryExecutor queryExecutor);

  ValueStream<FutureValue<T>> deriveQueryResultX(QueryExecutorX queryExecutorX);
}

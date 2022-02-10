import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:rxdart/rxdart.dart';

abstract class DerivedQueryRequest<R extends Record, T> extends QueryRequest<R, T> {
  Future<T> deriveQueryResult(QueryExecutor queryExecutor);

  ValueStream<FutureValue<T>> deriveQueryResultX(QueryExecutorX queryExecutorX);
}

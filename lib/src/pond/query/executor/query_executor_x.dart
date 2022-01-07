import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:rxdart/rxdart.dart';

abstract class QueryExecutorX extends QueryExecutor {
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest);
}

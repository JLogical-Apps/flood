import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:rxdart/rxdart.dart';

abstract class QueryExecutor {
  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest);

  Future<T> executeQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest, {Transaction? transaction});
}

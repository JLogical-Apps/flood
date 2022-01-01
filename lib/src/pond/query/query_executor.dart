import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

abstract class QueryExecutor {
  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {Transaction? transaction});
}
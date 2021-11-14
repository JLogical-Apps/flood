import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class QueryRequestReducer<Q extends QueryRequest<R, T>, R extends Record, T, C> {
  bool shouldReduce(QueryRequest queryRequest) => queryRequest is Q;

  T reduce({required C aggregate, required QueryRequest<R, T> queryRequest});
}

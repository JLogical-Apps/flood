import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractQueryRequestReducer<Q extends QueryRequest<R, T>, R extends Record, T, C>
    with WithSubtypeWrapper<Q, QueryRequest<R, T>>
    implements Wrapper<QueryRequest<R, T>> {
  T reduce({required C aggregate, required QueryRequest<R, T> queryRequest});
}

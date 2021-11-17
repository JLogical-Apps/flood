import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractQueryRequestReducer<Q extends AbstractQueryRequest<R, T>, R extends Record, T, C>
    with WithSubtypeWrapper<Q, AbstractQueryRequest<R, T>>
    implements Wrapper<AbstractQueryRequest<R, T>> {
  T reduce({required C aggregate, required AbstractQueryRequest<R, T> queryRequest});
}

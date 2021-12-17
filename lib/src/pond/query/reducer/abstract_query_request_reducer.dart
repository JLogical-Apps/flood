import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractQueryRequestReducer<QR extends AbstractQueryRequest<R, T>, R extends Record, T, C>
    with WithSubtypeWrapper<QR, AbstractQueryRequest<R, dynamic>>
    implements Wrapper<AbstractQueryRequest<R, dynamic>> {
  T reduce({required C accumulation, required QR queryRequest});
}

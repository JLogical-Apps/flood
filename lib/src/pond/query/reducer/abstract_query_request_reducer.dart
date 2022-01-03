import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractQueryRequestReducer<QR extends QueryRequest<R, T>, R extends Record, T, C>
    with WithSubtypeWrapper<QR, QueryRequest<R, dynamic>>
    implements Wrapper<QueryRequest<R, dynamic>> {
  T reduce({required C accumulation, required QR queryRequest});
}

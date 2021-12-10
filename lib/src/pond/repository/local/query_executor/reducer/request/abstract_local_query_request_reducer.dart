import 'package:jlogical_utils/src/pond/query/reducer/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractLocalQueryRequestReducer<QR extends AbstractQueryRequest<R, T>, R extends Record, T>
    extends AbstractQueryRequestReducer<QR, R, T, List<Record>> {}

import 'package:jlogical_utils/src/pond/query/reducer/request/query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AllQueryRequestReducer<R extends Record, C>
    extends QueryRequestReducer<AllQueryRequest<R>, R, List<R>, C> {}

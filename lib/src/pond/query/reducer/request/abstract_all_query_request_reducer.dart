import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractAllQueryRequestReducer<R extends Record, C>
    extends AbstractQueryRequestReducer<AllQueryRequest<R>, R, List<R>, C> {}

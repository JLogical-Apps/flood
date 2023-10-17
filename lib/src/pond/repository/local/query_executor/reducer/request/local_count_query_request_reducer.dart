import 'package:jlogical_utils/src/pond/query/request/count_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalCountQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<CountQueryRequest<R>, R, int> {
  @override
  int reduceSync({
    required Iterable<State> accumulation,
    required CountQueryRequest<R> queryRequest,
  }) {
    return accumulation.length;
  }
}

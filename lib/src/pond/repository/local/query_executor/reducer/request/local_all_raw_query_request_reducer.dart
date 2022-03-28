import 'package:jlogical_utils/src/pond/query/request/all_raw_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalAllRawQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<AllRawQueryRequest<R>, R, List<State>> {
  @override
  List<State> reduceSync({
    required Iterable<Record> accumulation,
    required AllRawQueryRequest<R> queryRequest,
  }) {
    return accumulation.map((record) => record.state).toList();
  }
}

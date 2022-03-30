import 'package:jlogical_utils/src/pond/query/request/all_raw_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_file_query_request_reducer.dart';

class FileAllRawQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<AllRawQueryRequest<R>, R, List<State>> {
  @override
  List<State> reduceSync({
    required Iterable<State> accumulation,
    required AllRawQueryRequest<R> queryRequest,
  }) {
    return accumulation.toList();
  }

  @override
  Future<void> inflate(List<State> output) async {}
}

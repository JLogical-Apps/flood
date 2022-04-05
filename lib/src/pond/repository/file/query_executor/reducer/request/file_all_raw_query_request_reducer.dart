import 'package:jlogical_utils/src/pond/query/request/all_raw_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_file_query_request_reducer.dart';

class FileAllRawQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<AllRawQueryRequest<R>, R, List<State>> {
  @override
  Future<List<State>> reduce({
    required Iterable<State> accumulation,
    required AllRawQueryRequest<R> queryRequest,
  }) async {
    return accumulation.toList();
  }
}

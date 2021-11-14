import 'package:jlogical_utils/src/pond/query/reducer/request/all_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalAllQueryRequestReducer<R extends Record> extends AllQueryRequestReducer<R, List<Record>> {
  @override
  List<R> reduce({
    required List<Record> aggregate,
    required QueryRequest<R, List<R>> queryRequest,
  }) {
    return aggregate.cast<R>();
  }
}

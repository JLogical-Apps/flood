import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_all_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalAllQueryRequestReducer<R extends Record> extends AbstractAllQueryRequestReducer<R, List<Record>> {
  @override
  List<R> reduce({
    required List<Record> aggregate,
    required AbstractQueryRequest<R, List<R>> queryRequest,
  }) {
    return aggregate.cast<R>().toList();
  }
}

import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_file_query_request_reducer.dart';

class FileAllQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<AllQueryRequest<R>, R, List<Record>> {
  @override
  List<R> reduceSync({
    required Iterable<Record> accumulation,
    required AllQueryRequest<R> queryRequest,
  }) {
    return accumulation.cast<R>().toList();
  }
}

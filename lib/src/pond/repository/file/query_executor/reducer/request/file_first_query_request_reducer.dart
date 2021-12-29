import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/first_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_file_query_request_reducer.dart';

class FileFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  @override
  R? reduce({
    required List<Record> accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) {
    return accumulation.firstOrNull as R?;
  }
}

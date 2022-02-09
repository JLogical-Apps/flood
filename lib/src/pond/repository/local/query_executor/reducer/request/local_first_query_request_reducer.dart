import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  @override
  R? reduceSync({
    required Iterable<Record> accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) {
    return accumulation.firstOrNull as R?;
  }
}

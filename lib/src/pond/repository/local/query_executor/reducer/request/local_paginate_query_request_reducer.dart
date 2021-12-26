import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalPaginateQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResult<R>> {
  @override
  QueryPaginationResult<R> reduce({
    required List<Record> accumulation,
    required PaginateQueryRequest<R> queryRequest,
  }) {
    return QueryPaginationResult.paginate(accumulation.cast<R>().toList(), limit: queryRequest.limit);
  }
}

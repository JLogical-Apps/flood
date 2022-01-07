import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_file_query_request_reducer.dart';

class FilePaginateQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  @override
  QueryPaginationResultController<R> reduce({
    required Iterable<Record> accumulation,
    required PaginateQueryRequest<R> queryRequest,
  }) {
    return QueryPaginationResultController(
        result: QueryPaginationResult.paginate(accumulation.cast<R>().toList(), limit: queryRequest.limit));
  }
}

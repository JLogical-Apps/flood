import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalPaginateQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  final Future Function(Entity entity) onEntityInflated;

  late List<R> results;

  LocalPaginateQueryRequestReducer({required this.onEntityInflated});

  @override
  QueryPaginationResultController<R> reduceSync({
    required Iterable<State> accumulation,
    required PaginateQueryRequest<R> queryRequest,
  }) {
    results = accumulation.map((state) => Entity.fromState(state)).cast<R>().toList();
    return QueryPaginationResultController(result: QueryPaginationResult.paginate(results, limit: queryRequest.limit));
  }

  @override
  Future<void> inflate(QueryPaginationResultController<R> output) async {
    await Future.wait(results.map((result) => onEntityInflated(result as Entity)));
  }
}

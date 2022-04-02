import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import '../../../../../query/query.dart';
import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalPaginateQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  final Future Function(Entity entity) onEntityInflated;
  final QueryPaginationResultController? Function(Query query)? sourcePaginationResultControllerByQueryGetter;

  late List<R> results;

  LocalPaginateQueryRequestReducer({
    required this.onEntityInflated,
    required this.sourcePaginationResultControllerByQueryGetter,
  });

  @override
  QueryPaginationResultController<R> reduceSync({
    required Iterable<State> accumulation,
    required PaginateQueryRequest<R> queryRequest,
  }) {
    results = accumulation.map((state) => Entity.fromState(state)).cast<R>().toList();

    final sourcePaginationController =
        sourcePaginationResultControllerByQueryGetter?.call(queryRequest.query) as QueryPaginationResultController<R>?;

    final controller = QueryPaginationResultController(
      result: QueryPaginationResult.paginate<R>(
        results,
        limit: null,
        postLoadNextGetter: sourcePaginationController?.canLoadMore == true
            ? () async {
                if (sourcePaginationController?.canLoadMore == true) {
                  return await _sourceNextGetter(() => sourcePaginationController!.loadMore());
                }
                return null;
              }
            : null,
      ),
    );
    return controller;
  }

  Future<QueryPaginationResult<R>?> _sourceNextGetter<R extends Record>(
    Future<QueryPaginationResult<R>?> resultGetter(),
  ) async {
    final newResult = await resultGetter();
    return newResult.mapIfNonNull((newResult) => QueryPaginationResult(
          results: newResult.results.where((result) => !results.contains(result)).toList(),
          nextGetter: newResult.nextGetter.mapIfNonNull((nextGetter) => () => _sourceNextGetter(() => nextGetter())),
        ));
  }

  @override
  Future<void> inflate(QueryPaginationResultController<R> output) async {
    await Future.wait(results.map((result) => onEntityInflated(result as Entity)));
  }
}

import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../../../query/query.dart';
import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalPaginateQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  final EntityInflater entityInflater;
  final QueryPaginationResultController? Function(Query query)? sourcePaginationResultControllerByQueryGetter;

  late List<R> results;

  LocalPaginateQueryRequestReducer({
    required this.entityInflater,
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
  Future<QueryPaginationResultController<R>> inflate(QueryPaginationResultController<R> output) async {
    final newStates = await Future.wait(results.map((entity) async {
      final state = entity.state;
      await entityInflater.initializeState(state);
      return state;
    }));

    final newResults = newStates.map((state) => Entity.fromState(state)).cast<R>().toList();
    await Future.wait(newResults.map((value) => entityInflater.inflateEntity(value as Entity)));

    results = newResults;

    return output;
  }
}

import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../query/query.dart';
import '../../../../../record/entity.dart';
import 'abstract_file_query_request_reducer.dart';

class FilePaginateQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  final EntityInflater entityInflater;
  final void Function(Query query, QueryPaginationResultController controller) onPaginationControllerCreated;

  late List<R> results;

  FilePaginateQueryRequestReducer({required this.entityInflater, required this.onPaginationControllerCreated});

  @override
  Future<QueryPaginationResultController<R>> reduce({
    required Iterable<State> accumulation,
    required PaginateQueryRequest<R> queryRequest,
  }) async {
    accumulation = accumulation.toList();
    await Future.wait(accumulation.map((state) => entityInflater.initializeState(state)));

    results = accumulation.map((state) => Entity.fromState(state)).cast<R>().toList();
    final controller = QueryPaginationResultController(
      result: await QueryPaginationResult.paginateWithProcessing(
        results,
        onProcess: (record) => entityInflater.inflateEntity(record as Entity),
        limit: queryRequest.limit,
      ),
    );
    onPaginationControllerCreated(queryRequest.query, controller);
    return controller;
  }
}

import 'package:drop_core/src/query/pagination/paginated_query_result.dart';
import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:drop_core/src/query/request/paginate_states_query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class PaginateStatesStateQueryRequestReducer
    extends StateQueryRequestReducer<PaginateStatesQueryRequest, PaginatedQueryResult<State>> {
  PaginateStatesStateQueryRequestReducer({required super.dropContext});

  @override
  PaginatedQueryResult<State> reduce(
    PaginateStatesQueryRequest queryRequest,
    Iterable<State> states, {
    Function(State state)? onStateRetrieved,
  }) {
    return PaginatedQueryResult(
      page: QueryResultPage.batched(
        items: states.toList(),
        batchSize: queryRequest.pageSize,
      ),
      onPageLoaded: onStateRetrieved == null
          ? null
          : (page) async {
              final states = await page.getItems();
              for (final state in states) {
                onStateRetrieved(state);
              }
            },
    );
  }
}

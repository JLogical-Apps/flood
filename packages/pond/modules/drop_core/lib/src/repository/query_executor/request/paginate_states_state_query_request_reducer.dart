import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:drop_core/src/query/request/paginate_states_query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class PaginateStatesStateQueryRequestReducer
    extends StateQueryRequestReducer<PaginateStatesQueryRequest, QueryResultPage<State>> {
  PaginateStatesStateQueryRequestReducer({required super.dropContext});

  @override
  QueryResultPage<State> reduce(PaginateStatesQueryRequest queryRequest, Iterable<State> states) {
    return QueryResultPage.batched(items: states.toList(), batchSize: queryRequest.pageSize);
  }
}

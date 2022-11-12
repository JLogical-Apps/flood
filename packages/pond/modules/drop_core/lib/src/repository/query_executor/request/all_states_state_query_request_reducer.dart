import 'package:drop_core/src/query/request/all_states_query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class AllStatesStateQueryRequestReducer<E extends Entity>
    extends StateQueryRequestReducer<AllStatesQueryRequest<E>, Entity, List<State>> {
  AllStatesStateQueryRequestReducer({required super.dropContext});

  @override
  List<State> reduce(AllStatesQueryRequest queryRequest, Iterable<State> states) {
    return states.toList();
  }
}

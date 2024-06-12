import 'dart:async';

import 'package:drop_core/src/query/request/all_states_query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class AllStatesStateQueryRequestReducer extends StateQueryRequestReducer<AllStatesQueryRequest, List<State>> {
  AllStatesStateQueryRequestReducer({required super.dropContext});

  @override
  Future<List<State>> reduce(
    AllStatesQueryRequest queryRequest,
    Iterable<State> states, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    for (final state in states) {
      await onStateRetrieved?.call(state);
    }
    return states.toList();
  }
}

import 'dart:async';

import 'package:drop_core/src/query/request/count_query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class CountStateQueryRequestReducer extends StateQueryRequestReducer<CountQueryRequest, int> {
  CountStateQueryRequestReducer({required super.dropContext});

  @override
  int reduce(
    CountQueryRequest queryRequest,
    Iterable<State> states, {
    FutureOr Function(State state)? onStateRetrieved,
  }) {
    return states.length;
  }
}

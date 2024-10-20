import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drop_core/src/query/request/first_or_null_state_query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class FirstOrNullStateStateQueryRequestReducer extends StateQueryRequestReducer<FirstOrNullStateQueryRequest, State?> {
  FirstOrNullStateStateQueryRequestReducer({required super.dropContext});

  @override
  Future<State?> reduce(
    FirstOrNullStateQueryRequest queryRequest,
    Iterable<State> states, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    final result = states.firstOrNull;
    if (result != null) {
      await onStateRetrieved?.call(result);
    }
    return result;
  }
}

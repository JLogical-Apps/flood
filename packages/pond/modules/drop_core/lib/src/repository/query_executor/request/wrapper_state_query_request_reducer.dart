import 'dart:async';

import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class WrapperStateQueryRequestReducer extends StateQueryRequestReducer<QueryRequestWrapper, dynamic> {
  final FutureOr<T> Function<T>(
    QueryRequest<dynamic, T> queryRequest,
    Iterable<State> states,
    Function(State state)? onStateRetreived,
  ) queryRequestResolver;

  WrapperStateQueryRequestReducer({required super.dropContext, required this.queryRequestResolver});

  @override
  dynamic reduce(
    QueryRequestWrapper queryRequest,
    Iterable<State> states, {
    Function(State state)? onStateRetrieved,
  }) {
    return queryRequestResolver(queryRequest.queryRequest, states, onStateRetrieved);
  }
}

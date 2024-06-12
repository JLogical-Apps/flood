import 'dart:async';

import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class MapStateQueryRequestReducer<E extends Entity, T>
    extends StateQueryRequestReducer<MapQueryRequest<E, dynamic, T>, T> {
  final FutureOr<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    Iterable<State> states,
    FutureOr Function(State state)? onStateRetreived,
  ) queryRequestResolver;

  MapStateQueryRequestReducer({
    required super.dropContext,
    required this.queryRequestResolver,
  });

  @override
  Future<T> reduce(
    MapQueryRequest<E, dynamic, T> queryRequest,
    Iterable<State> states, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    final sourceQueryRequestResult = await queryRequestResolver(
      queryRequest.sourceQueryRequest,
      states,
      onStateRetrieved,
    );
    return await queryRequest.doMap(dropContext, sourceQueryRequestResult);
  }
}

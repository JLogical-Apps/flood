import 'dart:async';

import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class MapStateQueryRequestReducer<T> extends StateQueryRequestReducer<MapQueryRequest<dynamic, T>, T> {
  final FutureOr<T> Function<T>(QueryRequest<T> queryRequest, Iterable<State> states) queryRequestResolver;

  MapStateQueryRequestReducer({
    required super.dropContext,
    required this.queryRequestResolver,
  });

  @override
  Future<T> reduce(MapQueryRequest<dynamic, T> queryRequest, Iterable<State> states) async {
    final sourceQueryRequestResult = await queryRequestResolver(queryRequest.sourceQueryRequest, states);
    return await queryRequest.map(sourceQueryRequestResult);
  }
}

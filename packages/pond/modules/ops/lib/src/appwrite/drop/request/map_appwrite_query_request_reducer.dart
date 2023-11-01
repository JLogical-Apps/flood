import 'dart:async';

import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_request_reducer.dart';
import 'package:drop_core/drop_core.dart';

class MapAppwriteQueryRequestReducer<E extends Entity, T>
    extends AppwriteQueryRequestReducer<MapQueryRequest<E, dynamic, T>, T> {
  final FutureOr<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    AppwriteQuery appwriteQuery,
    Function(State state)? onStateRetreived,
  ) queryRequestResolver;

  final Stream<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    AppwriteQuery appwriteQuery,
    Function(State state)? onStateRetreived,
  ) queryRequestResolverX;

  MapAppwriteQueryRequestReducer({
    required super.dropContext,
    super.inferredType,
    required this.queryRequestResolver,
    required this.queryRequestResolverX,
  });

  @override
  Future<T> reduce(
    MapQueryRequest<E, dynamic, T> queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final sourceQueryRequestResult = await queryRequestResolver(
      queryRequest.sourceQueryRequest,
      appwriteQuery,
      onStateRetrieved,
    );
    return await queryRequest.doMap(dropContext, sourceQueryRequestResult);
  }

  @override
  Stream<T> reduceX(
    MapQueryRequest<E, dynamic, T> queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    return queryRequestResolverX(
      queryRequest.sourceQueryRequest,
      appwriteQuery,
      onStateRetrieved,
    ).asyncMap((result) => queryRequest.doMap(dropContext, result));
  }
}

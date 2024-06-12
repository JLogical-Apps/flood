import 'dart:async';

import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_query_request_reducer.dart';
import 'package:drop_core/drop_core.dart';

class WrapperAppwriteQueryRequestReducer<E extends Entity, T>
    extends AppwriteQueryRequestReducer<QueryRequestWrapper<E, T>, T> {
  final FutureOr<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    AppwriteQuery appwriteQuery,
    FutureOr Function(State state)? onStateRetreived,
  ) queryRequestResolver;

  final Stream<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    AppwriteQuery appwriteQuery,
    FutureOr Function(State state)? onStateRetreived,
  ) queryRequestResolverX;

  WrapperAppwriteQueryRequestReducer({
    required super.dropContext,
    super.inferredType,
    required this.queryRequestResolver,
    required this.queryRequestResolverX,
  });

  @override
  Future<T> reduce(
    QueryRequestWrapper<E, T> queryRequest,
    AppwriteQuery appwriteQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    final sourceQueryRequestResult = await queryRequestResolver(
      queryRequest.queryRequest,
      appwriteQuery,
      onStateRetrieved,
    );
    return sourceQueryRequestResult;
  }

  @override
  Stream<T> reduceX(
    QueryRequestWrapper<E, T> queryRequest,
    AppwriteQuery appwriteQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) {
    return queryRequestResolverX(
      queryRequest.queryRequest,
      appwriteQuery,
      onStateRetrieved,
    );
  }
}

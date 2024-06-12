import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';

class MapFirebaseQueryRequestReducer<E extends Entity, T>
    extends FirebaseQueryRequestReducer<MapQueryRequest<E, dynamic, T>, T> {
  final FutureOr<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    firebase.Query firestoreQuery,
    FutureOr Function(State state)? onStateRetreived,
  ) queryRequestResolver;

  final Stream<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    firebase.Query firestoreQuery,
    FutureOr Function(State state)? onStateRetreived,
  ) queryRequestResolverX;

  MapFirebaseQueryRequestReducer({
    required super.dropContext,
    super.inferredType,
    required this.queryRequestResolver,
    required this.queryRequestResolverX,
  });

  @override
  Future<T> reduce(
    MapQueryRequest<E, dynamic, T> queryRequest,
    firebase.Query firestoreQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    final sourceQueryRequestResult = await queryRequestResolver(
      queryRequest.sourceQueryRequest,
      firestoreQuery,
      onStateRetrieved,
    );
    return await queryRequest.doMap(dropContext, sourceQueryRequestResult);
  }

  @override
  Stream<T> reduceX(
    MapQueryRequest<E, dynamic, T> queryRequest,
    firebase.Query firestoreQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) {
    return queryRequestResolverX(
      queryRequest.sourceQueryRequest,
      firestoreQuery,
      onStateRetrieved,
    ).asyncMap((result) => queryRequest.doMap(dropContext, result));
  }
}

import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

class WrapperFirebaseQueryRequestReducer<E extends Entity, T>
    extends FirebaseQueryRequestReducer<QueryRequestWrapper<E, T>, T> {
  final FutureOr<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    firebase.Query firestoreQuery,
    Function(State state)? onStateRetreived,
  ) queryRequestResolver;

  final Stream<T> Function<T>(
    QueryRequest<E, T> queryRequest,
    firebase.Query firestoreQuery,
    Function(State state)? onStateRetreived,
  ) queryRequestResolverX;

  WrapperFirebaseQueryRequestReducer({
    required super.dropContext,
    super.inferredType,
    required this.queryRequestResolver,
    required this.queryRequestResolverX,
  });

  @override
  Future<T> reduce(
    QueryRequestWrapper<E, T> queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final sourceQueryRequestResult = await queryRequestResolver(
      queryRequest.queryRequest,
      firestoreQuery,
      onStateRetrieved,
    );
    return sourceQueryRequestResult;
  }

  @override
  Stream<T> reduceX(
    QueryRequestWrapper<E, T> queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    return queryRequestResolverX(
      queryRequest.queryRequest,
      firestoreQuery,
      onStateRetrieved,
    );
  }
}

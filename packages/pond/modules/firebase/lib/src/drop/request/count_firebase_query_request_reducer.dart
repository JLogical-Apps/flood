import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';

class CountFirebaseQueryRequestReducer extends FirebaseQueryRequestReducer<CountQueryRequest, int> {
  CountFirebaseQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<int> reduce(
    CountQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final snap = await firestoreQuery.count().get();

    final state = snap.count!;
    return state;
  }

  @override
  Stream<int> reduceX(
    CountQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) async* {
    yield await reduce(queryRequest, firestoreQuery, onStateRetrieved: onStateRetrieved);
  }
}

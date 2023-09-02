import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';

class AllStatesFirebaseQueryRequestReducer extends FirebaseQueryRequestReducer<AllStatesQueryRequest, List<State>> {
  AllStatesFirebaseQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<List<State>> reduce(
    AllStatesQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final snap = await firestoreQuery.get(firebase.GetOptions(source: firebase.Source.server));

    final states = snap.docs.map(getStateFromDocument).toList();
    for (final state in states) {
      onStateRetrieved?.call(state);
    }
    return states;
  }

  @override
  Stream<List<State>> reduceX(
    AllStatesQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    return firestoreQuery.snapshots().map((snap) {
      final states = snap.docs.map(getStateFromDocument).toList();
      for (final state in states) {
        onStateRetrieved?.call(state);
      }
      return states;
    });
  }
}

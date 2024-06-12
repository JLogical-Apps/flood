import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';
import 'package:utils/utils.dart';

class FirstOrNullStateFirebaseQueryRequestReducer
    extends FirebaseQueryRequestReducer<FirstOrNullStateQueryRequest, State?> {
  FirstOrNullStateFirebaseQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<State?> reduce(
    FirstOrNullStateQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    final snap = await firestoreQuery.limit(1).get(firebase.GetOptions(source: firebase.Source.server));

    final state = snap.docs.firstOrNull?.mapIfNonNull(getStateFromDocument);
    if (state != null) {
      await onStateRetrieved?.call(state);
    }

    return state;
  }

  @override
  Stream<State?> reduceX(
    FirstOrNullStateQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) {
    return firestoreQuery.limit(1).snapshots().asyncMap((snap) async {
      final state = snap.docs.firstOrNull?.mapIfNonNull(getStateFromDocument);
      if (state != null) {
        await onStateRetrieved?.call(state);
      }

      return state;
    });
  }
}

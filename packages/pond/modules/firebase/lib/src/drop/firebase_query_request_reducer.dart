import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_timestamp_state_persister_modifier.dart';
import 'package:type/type.dart';
import 'package:utils/utils.dart';

abstract class FirebaseQueryRequestReducer<QR extends QueryRequest<dynamic, T>, T> extends Modifier<QueryRequest> {
  final DropCoreContext dropContext;
  final RuntimeType? inferredType;

  late StatePersister<Map<String, dynamic>> statePersister = StatePersister.json(
    context: dropContext,
    extraStatePersisterModifiers: [
      FirebaseTimestampStatePersisterModifier(),
    ],
  );

  FirebaseQueryRequestReducer({required this.dropContext, required this.inferredType});

  @override
  bool shouldModify(QueryRequest input) {
    return input is QR;
  }

  FutureOr<T> reduce(
    QR queryRequest,
    firebase.Query firestoreQuery, {
    required Function(State state)? onStateRetrieved,
  });

  Stream<T> reduceX(
    QR queryRequest,
    firebase.Query firestoreQuery, {
    required Function(State state)? onStateRetrieved,
  });

  State getStateFromDocument(firebase.QueryDocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    json[State.idField] = doc.id;
    if (inferredType != null) {
      json[State.typeField] = inferredType!;
    }

    return statePersister.inflate(json);
  }
}

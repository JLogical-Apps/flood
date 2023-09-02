import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_reducer.dart';

class OrderByFirebaseQueryReducer extends FirebaseQueryReducer<OrderByQuery> {
  @override
  firebase.Query reduce(OrderByQuery query, firebase.Query? currentFirestoreQuery) {
    return currentFirestoreQuery!.orderBy(
      query.stateField,
      descending: query.type == OrderByType.descending,
    );
  }
}

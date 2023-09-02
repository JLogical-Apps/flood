import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_reducer.dart';

class LimitFirebaseQueryReducer extends FirebaseQueryReducer<LimitQuery> {
  @override
  firebase.Query reduce(LimitQuery query, firebase.Query? currentFirestoreQuery) {
    return currentFirestoreQuery!.limit(query.limit);
  }
}

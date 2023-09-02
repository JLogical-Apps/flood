import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/condition/firebase_query_condition_reducer.dart';

class ContainsFirebaseQueryConditionReducer extends FirebaseQueryConditionReducer<ContainsQueryCondition> {
  @override
  firebase.Query reduce(ContainsQueryCondition condition, firebase.Query currentFirestoreQuery) {
    return currentFirestoreQuery.where(condition.stateField, arrayContains: condition.value);
  }
}

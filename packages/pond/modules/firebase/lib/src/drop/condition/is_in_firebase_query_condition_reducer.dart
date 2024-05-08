import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/condition/firebase_query_condition_reducer.dart';

class IsInFirebaseQueryConditionReducer extends FirebaseQueryConditionReducer<IsInQueryCondition> {
  @override
  firebase.Query reduce(IsInQueryCondition condition, firebase.Query currentFirestoreQuery) {
    return currentFirestoreQuery.where(condition.stateField, whereIn: condition.values);
  }
}

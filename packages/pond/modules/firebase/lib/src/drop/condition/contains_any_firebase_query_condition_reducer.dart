import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/condition/firebase_query_condition_reducer.dart';

class ContainsAnyFirebaseQueryConditionReducer extends FirebaseQueryConditionReducer<ContainsAnyQueryCondition> {
  @override
  firebase.Query reduce(ContainsAnyQueryCondition condition, firebase.Query currentFirestoreQuery) {
    return currentFirestoreQuery.where(condition.stateField, arrayContainsAny: condition.values);
  }
}

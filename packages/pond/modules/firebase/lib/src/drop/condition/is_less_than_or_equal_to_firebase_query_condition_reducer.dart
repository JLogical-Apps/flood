import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/condition/firebase_query_condition_reducer.dart';

class IsLessThanOrEqualToFirebaseQueryConditionReducer
    extends FirebaseQueryConditionReducer<IsLessThanOrEqualToQueryCondition> {
  @override
  firebase.Query reduce(IsLessThanOrEqualToQueryCondition condition, firebase.Query currentFirestoreQuery) {
    return currentFirestoreQuery.where(condition.stateField, isLessThanOrEqualTo: condition.value);
  }
}

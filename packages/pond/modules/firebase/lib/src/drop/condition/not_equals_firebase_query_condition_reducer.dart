import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/condition/firebase_query_condition_reducer.dart';
import 'package:utils/utils.dart';

class NotEqualsFirebaseQueryConditionReducer extends FirebaseQueryConditionReducer<NotEqualsQueryCondition> {
  @override
  firebase.Query reduce(NotEqualsQueryCondition condition, firebase.Query currentFirestoreQuery) {
    return guard(() => withWhere(condition, currentFirestoreQuery)) ?? currentFirestoreQuery;
  }

  firebase.Query withWhere(NotEqualsQueryCondition condition, firebase.Query currentFirestoreQuery) {
    if (condition.stateField == State.idField) {
      return currentFirestoreQuery.where(firebase.FieldPath.documentId, isNotEqualTo: condition.value);
    }

    if (condition.value == null) {
      return currentFirestoreQuery.where(condition.stateField, isNull: false);
    }

    var compareTo = condition.value;
    if (compareTo is DateTime) {
      compareTo = compareTo.millisecondsSinceEpoch;
    }
    return currentFirestoreQuery.where(condition.stateField, isNotEqualTo: compareTo);
  }
}

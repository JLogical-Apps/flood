import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/condition/contains_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/equals_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/is_greater_than_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/is_greater_than_or_equal_to_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/is_less_than_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/is_less_than_or_equal_to_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/is_non_null_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/condition/is_null_firebase_query_condition_reducer.dart';
import 'package:firebase/src/drop/firebase_query_reducer.dart';
import 'package:utils/utils.dart';

class WhereFirebaseQueryReducer extends FirebaseQueryReducer<WhereQuery> {
  ModifierResolver<FirebaseQueryConditionReducer, QueryCondition> getQueryConditionReducerResolver() =>
      ModifierResolver(modifiers: [
        ContainsFirebaseQueryConditionReducer(),
        EqualsFirebaseQueryConditionReducer(),
        IsGreaterThanOrEqualToFirebaseQueryConditionReducer(),
        IsGreaterThanFirebaseQueryConditionReducer(),
        IsLessThanOrEqualToFirebaseQueryConditionReducer(),
        IsLessThanFirebaseQueryConditionReducer(),
        IsNonNullFirebaseQueryConditionReducer(),
        IsNullFirebaseQueryConditionReducer(),
      ]);

  @override
  firebase.Query reduce(WhereQuery query, firebase.Query? currentFirestoreQuery) {
    return getQueryConditionReducerResolver().resolve(query.condition).reduce(query.condition, currentFirestoreQuery!);
  }
}

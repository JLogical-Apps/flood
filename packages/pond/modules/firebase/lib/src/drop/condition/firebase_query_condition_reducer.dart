import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

abstract class FirebaseQueryConditionReducer<QC extends QueryCondition> extends Modifier<QueryCondition> {
  @override
  bool shouldModify(QueryCondition input) {
    return input is QC;
  }

  firebase.Query reduce(QC condition, firebase.Query currentFirestoreQuery);
}

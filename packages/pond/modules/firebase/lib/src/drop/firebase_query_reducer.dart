import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';

abstract class FirebaseQueryReducer<Q extends Query> extends Modifier<Query> {
  @override
  bool shouldModify(Query input) {
    return input is Q;
  }

  firebase.Query reduce(Q query, firebase.Query? currentFirestoreQuery);
}

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_from_query_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class FirestoreFromQueryReducer extends AbstractFromQueryReducer<firestore.Query> {
  final String collectionPath;

  final Future<State> Function(String id) stateGetter;

  const FirestoreFromQueryReducer({required this.collectionPath, required this.stateGetter});

  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    final descendants = AppContext.global.getDescendants(query.recordType);
    final types = {...descendants, query.recordType};
    final typeNames = types.map((type) => type.toString()).toList();

    final collection = firestore.FirebaseFirestore.instance.collection(collectionPath);

    return collection.where(Query.type, whereIn: typeNames);
  }
}

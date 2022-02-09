import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/from_query.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';

class FirestoreFromQueryReducer extends AbstractQueryReducer<FromQuery, firestore.Query> {
  final String collectionPath;
  final Type? inferredType;

  const FirestoreFromQueryReducer({
    required this.collectionPath,
    this.inferredType,
  });

  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    final collection = firestore.FirebaseFirestore.instance.collection(collectionPath);

    if (query.recordType == inferredType) {
      return collection;
    }

    final descendants = AppContext.global.getDescendants(query.recordType);
    final types = {...descendants, query.recordType};
    final typeNames = types.map((type) => type.toString()).toList();

    return collection.where(Query.type, whereIn: typeNames);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/from_query.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';

import '../../../../../record/entity.dart';

class FirestoreFromQueryReducer extends AbstractQueryReducer<FromQuery, firestore.Query> {
  final String collectionPath;
  final String unionTypeFieldName;
  final String Function(String typeName) unionTypeConverter;
  final Type? inferredType;

  const FirestoreFromQueryReducer({
    required this.collectionPath,
    required this.unionTypeFieldName,
    required this.unionTypeConverter,
    this.inferredType,
  });

  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    final collection = firestore.FirebaseFirestore.instance.collection(collectionPath);

    if (query.recordType == inferredType) {
      return collection;
    }

    final shouldNarrowByType = query.recordType != Entity;
    if (!shouldNarrowByType) {
      return collection;
    }

    final descendants = AppContext.global.getDescendants(query.recordType);
    final types = {...descendants, query.recordType};
    final typeNames = types.map((type) => unionTypeConverter(type.toString())).toList();

    return collection.where(unionTypeFieldName, whereIn: typeNames);
  }
}
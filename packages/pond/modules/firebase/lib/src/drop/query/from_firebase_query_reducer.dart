import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_reducer.dart';
import 'package:type/type.dart';

class FromFirebaseQueryReducer extends FirebaseQueryReducer<FromQuery> {
  final DropCoreContext context;
  final String rootPath;

  final RuntimeType? inferredType;

  FromFirebaseQueryReducer({required this.context, required this.rootPath, this.inferredType});

  @override
  firebase.Query reduce(FromQuery query, firebase.Query? currentFirestoreQuery) {
    final collection = firebase.FirebaseFirestore.instance.collection(rootPath);
    final queryEntityRuntimeType = context.getRuntimeTypeRuntime(query.entityType);

    if (queryEntityRuntimeType == inferredType) {
      return collection;
    }

    final shouldNarrowByType = query.entityType != Entity;
    if (!shouldNarrowByType) {
      return collection;
    }

    final descendants = context.getDescendantsOf(queryEntityRuntimeType);
    final types = {...descendants, queryEntityRuntimeType};
    final typeNames = types.map((type) => type.name).toList();

    return collection.where(State.typeField, whereIn: typeNames);
  }
}

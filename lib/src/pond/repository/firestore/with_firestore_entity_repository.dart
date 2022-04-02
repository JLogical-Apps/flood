import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/jlogical_utils.dart';

import 'query_executor/firestore_query_executor.dart';

mixin WithFirestoreEntityRepository on EntityRepository implements WithCacheEntityRepository {
  String get dataPath;

  /// The name of the field that stores the union type of
  String get unionTypeFieldName => Query.type;

  /// Converts [typeName] (the name of a type that extends `E`) to a string to be queried/saved.
  /// The state of extracted documents will find the first [typeName] in the list of handled types that has the same value.
  String unionTypeConverter(String typeName) {
    return typeName;
  }

  /// The type to infer documents without a union type are.
  /// If saving an entity with a type of [inferredType], omit the union field to save space.
  Type? get inferredType;

  firestore.CollectionReference get _collection => firestore.FirebaseFirestore.instance.collection(dataPath);

  @override
  Future<void> save(Entity entity) {
    return _saveState(id: entity.id!, state: entity.state);
  }

  Future<void> _saveState({required String id, required State state}) async {
    final doc = _collection.doc(id);
    final json = state.fullValues;
    json.remove(Query.id);

    if (state.type == inferredType?.toString()) {
      json.remove(Query.type);
    } else {
      final stateType = json.remove(Query.type);
      json[unionTypeFieldName] = unionTypeConverter(stateType);
    }

    await doc.set(json);
  }

  @override
  Future<Entity?> getOrNull(String id, {bool withoutCache: false}) async {
    final doc = _collection.doc(id);
    final snap = await doc.get(firestore.GetOptions(source: firestore.Source.server));

    if (!snap.exists) {
      return null;
    }

    final state = State.extractFromOrNull(
      snap.data(),
      idOverride: snap.id,
      typeFallback: inferredType?.toString(),
    );
    if (state == null) {
      return null;
    }

    return Entity.fromStateOrNull(state);
  }

  @override
  Future<void> delete(Entity entity) async {
    final id = entity.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));
    final doc = _collection.doc(id);
    await doc.delete();
  }

  QueryExecutor getQueryExecutor({
    required void onPaginationControllerCreated(Query query, QueryPaginationResultController controller),
  }) {
    return FirestoreQueryExecutor(
      collectionPath: dataPath,
      onEntityInflated: (entity) async {
        saveToCache(entity);
        await entity.onInitialize();
      },
      unionTypeFieldName: unionTypeFieldName,
      unionTypeConverter: unionTypeConverter,
      validTypes: handledEntityTypes,
      inferredType: inferredType,
      onPaginationControllerCreated: onPaginationControllerCreated,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';

import 'query_executor/firestore_query_executor.dart';

mixin WithFirestoreEntityRepository on EntityRepository implements WithTransactionsAndCacheEntityRepository {
  String get collectionPath;

  firestore.CollectionReference get _collection => firestore.FirebaseFirestore.instance.collection(collectionPath);

  @override
  Future<void> save(Entity entity, {Transaction? transaction}) {
    return _saveState(id: entity.id!, state: entity.state);
  }

  Future<void> _saveState({required String id, required State state}) async {
    final doc = _collection.doc(id);
    final json = state.fullValues;
    await doc.set(json);
  }

  @override
  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false}) async {
    final doc = _collection.doc(id);
    final snap = await doc.get(firestore.GetOptions(source: firestore.Source.server));

    if (!snap.exists) {
      return null;
    }

    final state = State.extractFromOrNull(snap.data());
    if (state == null) {
      return null;
    }

    return Entity.fromStateOrNull(state);
  }

  @override
  Future<void> delete(Entity entity, {Transaction? transaction}) async {
    final id = entity.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));
    final doc = _collection.doc(id);
    await doc.delete();
  }

  Future<void> commitTransactionChanges(TransactionPendingChanges changes) async {
    await Future.wait(changes.stateChangesById.entries.mapEntries((id, state) => _saveState(id: id, state: state)));
    await Future.wait(changes.stateIdDeletes.map((id) async {
      final entity =
          await getOrNull(id) ?? (throw Exception('Cannot delete entity with id [$id] since it does not exist!'));
      await delete(entity);
    }));
  }

  QueryExecutor getQueryExecutor({Transaction? transaction}) {
    return FirestoreQueryExecutor(
      collectionPath: collectionPath,
      stateGetter: (id, withoutCache) async =>
          (await get(id, transaction: transaction, withoutCache: withoutCache)).state,
    );
  }
}

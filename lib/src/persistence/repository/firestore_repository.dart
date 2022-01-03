import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jlogical_utils/src/model/pagination_result.dart';
import 'package:jlogical_utils/src/persistence/repository/repository.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';
import 'package:jlogical_utils/src/utils/util.dart';

abstract class FirestoreRepository<T> extends Repository<T, String> {
  /// The path of the collection.
  final String collectionPath;

  final T Function(Map<String, dynamic> json) fromJson;

  final Map<String, dynamic> Function(T object) toJson;

  final Query Function(Query query)? defaultQueryModifier;

  late final CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection(collectionPath);

  FirestoreRepository({
    required this.collectionPath,
    required this.fromJson,
    required this.toJson,
    this.defaultQueryModifier,
  });

  @override
  Future<String> generateId() async {
    final doc = await collection.doc();
    return doc.id;
  }

  @override
  Future<String> create(T object) async {
    final id = await generateId();

    final json = toJson(object);
    await collection.doc(id).set(json);

    return id;
  }

  @override
  Future<T?> get(String id) async {
    final doc = collection.doc(id);

    final snap = await doc.get();
    return _getDataFromDocumentSnapshot(snap);
  }

  @override
  Future<void> save(String id, T object) async {
    final doc = collection.doc(id);

    final json = toJson(object);
    await doc.set(json, SetOptions(merge: true));
  }

  @override
  Future<void> delete(String id) async {
    final doc = collection.doc(id);

    await doc.delete();
  }

  @override
  Future<PaginationResult<T>> getAll({int? limit, Query modifier(Query query)?}) async {
    if (limit == null) {
      final query = _getModifiedQuery(query: collection, modifier: modifier);
      final snap = await query.get();
      final results = _getDataFromCollectionSnapshot(snap);
      return PaginationResult(
        results: results,
        nextPageGetter: null,
      );
    }

    return await _getRange(limit: limit, modifier: modifier);
  }

  Future<PaginationResult<T>> _getRange({
    required int limit,
    DocumentSnapshot? startAfter,
    Query modifier(Query query)?,
  }) async {
    final query = collection.limit(limit);
    var modifiedQuery = _getModifiedQuery(query: query, modifier: modifier);
    if (startAfter != null) {
      modifiedQuery = modifiedQuery.startAfterDocument(startAfter);
    }

    final snap = await modifiedQuery.get();
    final results = _getDataFromCollectionSnapshot(snap);

    return PaginationResult(
      results: results,
      nextPageGetter: snap.size == limit
          ? () => _getRange(
                limit: limit,
                modifier: modifier,
                startAfter: snap.docs.last,
              )
          : null,
    );
  }

  Query _getModifiedQuery({required Query query, Query modifier(Query query)?}) {
    if (modifier != null) return modifier(query);
    if (defaultQueryModifier != null) return defaultQueryModifier!(query);
    return query;
  }

  T? _getDataFromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    final json = data?.as<Map<String, dynamic>>();
    return json.mapIfNonNull((json) => fromJson(json));
  }

  Map<String, T> _getDataFromCollectionSnapshot(QuerySnapshot snap) {
    final docs = snap.docs;
    return docs.tryMap((docSnapshot) => MapEntry(docSnapshot.id, _getDataFromDocumentSnapshot(docSnapshot)!)).toMap();
  }
}

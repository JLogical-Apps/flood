import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreAllQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<AllQueryRequest<R>, R, List<Record>> {
  final Type? inferredType;
  final Future Function(Entity entity) onEntityInflated;

  FirestoreAllQueryRequestReducer({required this.inferredType, required this.onEntityInflated});

  @override
  Future<List<R>> reduce({
    required firestore.Query accumulation,
    required AllQueryRequest<R> queryRequest,
  }) async {
    final snap = await accumulation.get();
    final records = snap.docs
        .map((doc) =>
            State.extractFromOrNull(
              doc.data(),
              idOverride: doc.id,
              typeFallback: inferredType?.toString(),
            ) ??
            (throw Exception('Cannot get state from Firestore data! [${doc.data()}]')))
        .map((state) => Entity.fromState(state))
        .map((entity) => entity as R)
        .toList();
    await Future.wait(records.map((r) => onEntityInflated(r as Entity)));
    return records;
  }
}

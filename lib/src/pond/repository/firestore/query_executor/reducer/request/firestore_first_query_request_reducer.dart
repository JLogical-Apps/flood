import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  final String unionTypeFieldName;
  final Type? inferredType;
  final String Function(String unionTypeValue) typeNameFromUnionTypeValueGetter;
  final Future Function(Entity entity) onEntityInflated;

  FirestoreFirstOrNullQueryRequestReducer({
    required this.unionTypeFieldName,
    required this.inferredType,
    required this.typeNameFromUnionTypeValueGetter,
    required this.onEntityInflated,
  });

  @override
  Future<R?> reduce({
    required firestore.Query accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) async {
    final snap = await accumulation.get();
    final record = snap.docs
        .map((doc) =>
            State.extractFromOrNull(
              doc.data(),
              idOverride: doc.id,
              typeFallback: inferredType?.toString() ?? typeNameFromUnionTypeValueGetter(doc[unionTypeFieldName]),
            ) ??
            (throw Exception('Cannot get state from Firestore data! [${doc.data()}]')))
        .map((state) => Entity.fromState(state))
        .map((entity) => entity as R)
        .firstOrNull;

    if (record != null) {
      await onEntityInflated(record as Entity);
    }

    return record;
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/with_first_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?>
    with WithFirstQueryRequestReducer<R, firestore.Query> {
  final String unionTypeFieldName;
  final Type? inferredType;
  final String Function(String unionTypeValue) typeNameFromUnionTypeValueGetter;

  @override
  final EntityInflater entityInflater;

  FirestoreFirstOrNullQueryRequestReducer({
    required this.unionTypeFieldName,
    required this.inferredType,
    required this.typeNameFromUnionTypeValueGetter,
    required this.entityInflater,
  });

  @override
  FutureOr<State?> getState(firestore.Query<Object?> accumulation) async {
    final snap = await accumulation.get();
    return snap.docs.firstOrNull.mapIfNonNull((doc) =>
        State.extractFromOrNull(
          doc.data(),
          idOverride: doc.id,
          typeFallback: inferredType?.toString() ?? typeNameFromUnionTypeValueGetter(doc[unionTypeFieldName]),
        ) ??
        (throw Exception('Cannot get state from Firestore data! [${doc.data()}]')));
  }
}

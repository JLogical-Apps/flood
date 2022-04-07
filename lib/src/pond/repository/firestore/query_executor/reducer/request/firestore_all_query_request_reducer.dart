import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/reducer/request/with_all_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../query/reducer/entity_inflater.dart';
import 'abstract_firestore_query_request_reducer.dart';

class FirestoreAllQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<AllQueryRequest<R>, R, List<R>>
    with WithAllQueryRequestReducer<R, firestore.Query> {
  final String unionTypeFieldName;
  final Type? inferredType;
  final String Function(String unionTypeValue) typeNameFromUnionTypeValueGetter;

  final EntityInflater entityInflater;

  FirestoreAllQueryRequestReducer({
    required this.unionTypeFieldName,
    required this.inferredType,
    required this.typeNameFromUnionTypeValueGetter,
    required this.entityInflater,
  });

  FutureOr<List<State>> getStates(firestore.Query accumulation) async {
    final snap = await accumulation.get();
    return snap.docs
        .map((doc) =>
            State.extractFromOrNull(
              doc.data(),
              idOverride: doc.id,
              typeFallback: inferredType?.toString() ?? typeNameFromUnionTypeValueGetter(doc[unionTypeFieldName]),
            ) ??
            (throw Exception('Cannot get state from Firestore data! [${doc.data()}]')))
        .toList();
  }
}

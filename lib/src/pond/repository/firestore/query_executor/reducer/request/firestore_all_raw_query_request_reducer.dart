import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/request/all_raw_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreAllRawQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<AllRawQueryRequest<R>, R, List<State>> {
  final String unionTypeFieldName;
  final Type? inferredType;
  final String Function(String unionTypeValue) typeNameFromUnionTypeValueGetter;

  FirestoreAllRawQueryRequestReducer({
    required this.unionTypeFieldName,
    required this.inferredType,
    required this.typeNameFromUnionTypeValueGetter,
  });

  @override
  Future<List<State>> reduce({
    required firestore.Query accumulation,
    required AllRawQueryRequest<R> queryRequest,
  }) async {
    final snap = await accumulation.get();
    final states = snap.docs
        .map((doc) =>
            State.extractFromOrNull(
              doc.data(),
              idOverride: doc.id,
              typeFallback: inferredType?.toString() ?? typeNameFromUnionTypeValueGetter(doc[unionTypeFieldName]),
            ) ??
            (throw Exception('Cannot get state from Firestore data! [${doc.data()}]')))
        .toList();
    return states;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  @override
  Future<R?> reduce({
    required firestore.Query accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) async {
    final snap = await accumulation.get();
    return snap.docs
        .map((e) =>
            State.extractFromOrNull(e.data()) ??
            (throw Exception('Cannot get state from Firestore data! [${e.data()}]')))
        .map((state) => Entity.fromState(state))
        .map((entity) => entity as R)
        .firstOrNull;
  }
}

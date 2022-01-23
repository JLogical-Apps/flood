import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreAllQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<AllQueryRequest<R>, R, List<Record>> {
  @override
  Future<List<R>> reduce({
    required firestore.Query accumulation,
    required AllQueryRequest<R> queryRequest,
  }) async {
    final snap = await accumulation.get();
    return snap.docs
        .map((e) =>
            State.extractFromOrNull(e.data()) ??
            (throw Exception('Cannot get state from Firestore data! [${e.data()}]')))
        .map((state) => Entity.fromState(state))
        .map((entity) => entity as R)
        .toList();
  }
}

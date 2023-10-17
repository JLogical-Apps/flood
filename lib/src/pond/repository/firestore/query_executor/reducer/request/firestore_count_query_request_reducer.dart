import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/request/count_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreCountQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<CountQueryRequest<R>, R, int> {
  @override
  Future<int> reduce({
    required firestore.Query<Object?> accumulation,
    required CountQueryRequest<R> queryRequest,
  }) async {
    final s = await accumulation.count().get();
    return s.count;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestorePaginateQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  final Type? inferredType;
  final void Function(Entity entity) onEntityInflated;

  FirestorePaginateQueryRequestReducer({required this.inferredType, required this.onEntityInflated});

  @override
  Future<QueryPaginationResultController<R>> reduce({
    required firestore.Query accumulation,
    required PaginateQueryRequest<R> queryRequest,
  }) async {
    final paginationResult = await _paginate<R>(
      query: accumulation,
      lastSnap: null,
      limit: queryRequest.limit,
    );

    return QueryPaginationResultController(result: paginationResult);
  }

  Future<QueryPaginationResult<R>> _paginate<R extends Record>({
    required firestore.Query query,
    required firestore.DocumentSnapshot? lastSnap,
    required int limit,
  }) async {
    var paginateQuery = query.limit(limit);
    if (lastSnap != null) {
      paginateQuery = paginateQuery.startAfterDocument(lastSnap);
    }

    final snap = await paginateQuery.get(firestore.GetOptions(source: Source.server));
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

    records.forEach((r) => onEntityInflated(r as Entity));

    return QueryPaginationResult<R>(
      results: records,
      nextGetter:
          snap.size == limit ? () => _paginate(query: query, lastSnap: snap.docs.lastOrNull, limit: limit) : null,
    );
  }
}

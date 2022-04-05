import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../query/query.dart';
import 'abstract_firestore_query_request_reducer.dart';

class FirestorePaginateQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<PaginateQueryRequest<R>, R, QueryPaginationResultController<R>> {
  final String unionTypeFieldName;
  final Type? inferredType;
  final String Function(String unionTypeValue) typeNameFromUnionTypeValueGetter;
  final Future Function(Entity entity) onEntityInflated;
  final void Function(Query query, QueryPaginationResultController controller) onPaginationControllerCreated;

  FirestorePaginateQueryRequestReducer({
    required this.unionTypeFieldName,
    required this.inferredType,
    required this.typeNameFromUnionTypeValueGetter,
    required this.onEntityInflated,
    required this.onPaginationControllerCreated,
  });

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

    final controller = QueryPaginationResultController(result: paginationResult);
    onPaginationControllerCreated(queryRequest.query, controller);
    return controller;
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

    final snap = await paginateQuery.get(firestore.GetOptions(source: firestore.Source.server));
    final records = snap.docs
        .map((doc) =>
            State.extractFromOrNull(
              doc.data(),
              idOverride: doc.id,
              typeFallback: inferredType?.toString() ?? typeNameFromUnionTypeValueGetter(doc[unionTypeFieldName]),
            ) ??
            (throw Exception('Cannot get state from Firestore data! [${doc.data()}]')))
        .map((state) => Entity.fromState(state))
        .map((entity) => entity as R)
        .toList();

    await Future.wait(records.map((r) => onEntityInflated(r as Entity)));

    return QueryPaginationResult<R>(
      results: records,
      nextGetter:
          snap.size == limit ? () => _paginate(query: query, lastSnap: snap.docs.lastOrNull, limit: limit) : null,
    );
  }
}

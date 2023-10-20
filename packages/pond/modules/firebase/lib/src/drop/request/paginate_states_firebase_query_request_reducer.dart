import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';

class PaginateStatesFirebaseQueryRequestReducer
    extends FirebaseQueryRequestReducer<PaginateStatesQueryRequest, PaginatedQueryResult<State>> {
  PaginateStatesFirebaseQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<PaginatedQueryResult<State>> reduce(
    PaginateStatesQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final page = await _paginate(
      query: firestoreQuery,
      lastSnap: null,
      limit: queryRequest.pageSize,
      onStateRetrieved: onStateRetrieved,
    );

    return PaginatedQueryResult(page: page);
  }

  @override
  Stream<PaginatedQueryResult<State>> reduceX(
    PaginateStatesQueryRequest queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    throw UnimplementedError();
  }

  Future<QueryResultPage<State>> _paginate({
    required firebase.Query query,
    required firebase.DocumentSnapshot? lastSnap,
    required int limit,
    Function(State state)? onStateRetrieved,
  }) async {
    var paginateQuery = query.limit(limit);
    if (lastSnap != null) {
      paginateQuery = paginateQuery.startAfterDocument(lastSnap);
    }

    final snap = await paginateQuery.get(firebase.GetOptions(source: firebase.Source.server));
    final states = snap.docs.map(getStateFromDocument).toList();

    for (final state in states) {
      onStateRetrieved?.call(state);
    }

    return QueryResultPage(
      items: states,
      nextPageGetter: snap.size == limit
          ? () => _paginate(
                query: query,
                lastSnap: snap.docs.lastOrNull,
                limit: limit,
                onStateRetrieved: onStateRetrieved,
              )
          : null,
    );
  }
}

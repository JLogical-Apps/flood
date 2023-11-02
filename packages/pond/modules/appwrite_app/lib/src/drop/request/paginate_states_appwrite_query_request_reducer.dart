import 'dart:async';

import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite_app/src/drop/appwrite_cloud_repository.dart';
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_query_request_reducer.dart';
import 'package:drop_core/drop_core.dart';

class PaginateStatesAppwriteQueryRequestReducer
    extends AppwriteQueryRequestReducer<PaginateStatesQueryRequest, PaginatedQueryResult<State>> {
  PaginateStatesAppwriteQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<PaginatedQueryResult<State>> reduce(
    PaginateStatesQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final page = await _paginate(
      query: appwriteQuery,
      lastDocumentId: null,
      limit: queryRequest.pageSize,
      onStateRetrieved: onStateRetrieved,
    );

    return PaginatedQueryResult(page: page);
  }

  @override
  Stream<PaginatedQueryResult<State>> reduceX(
    PaginateStatesQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    throw UnimplementedError();
  }

  Future<QueryResultPage<State>> _paginate({
    required AppwriteQuery query,
    required String? lastDocumentId,
    required int limit,
    Function(State state)? onStateRetrieved,
  }) async {
    var paginateQuery = query.withQuery(appwrite.Query.limit(limit));
    if (lastDocumentId != null) {
      paginateQuery = paginateQuery.withQuery(appwrite.Query.cursorAfter(lastDocumentId));
    }

    final documents = await query.databases.listDocuments(
      databaseId: AppwriteCloudRepository.defaultDatabaseId,
      collectionId: query.collectionId,
      queries: query.queries,
    );

    final states = documents.documents.map(getStateFromDocument).toList();
    for (final state in states) {
      onStateRetrieved?.call(state);
    }

    return QueryResultPage(
      items: states,
      nextPageGetter: documents.total == limit
          ? () => _paginate(
                query: query,
                lastDocumentId: documents.documents.lastOrNull?.$id,
                limit: limit,
                onStateRetrieved: onStateRetrieved,
              )
          : null,
    );
  }
}
import 'dart:async';

import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_cloud_repository.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_request_reducer.dart';

class AllStatesAppwriteQueryRequestReducer extends AppwriteQueryRequestReducer<AllStatesQueryRequest, List<State>> {
  AllStatesAppwriteQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<List<State>> reduce(
    AllStatesQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    final queries = [
      ...appwriteQuery.queries,
      if (!appwriteQuery.queries.any((query) => query.startsWith('limit'))) appwrite.Query.limit(500),
    ];

    final documents = await appwriteQuery.databases.listDocuments(
      databaseId: AppwriteCloudRepository.defaultDatabaseId,
      collectionId: appwriteQuery.collectionId,
      queries: queries,
    );

    final states = documents.documents.map(getStateFromDocument).toList();
    for (final state in states) {
      onStateRetrieved?.call(state);
    }
    return states;
  }

  @override
  Stream<List<State>> reduceX(
    AllStatesQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    throw Exception('Stream of documents from a query is not supported.');
  }
}

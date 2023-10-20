import 'dart:async';

import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite_app/src/drop/appwrite_cloud_repository.dart';
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_query_request_reducer.dart';
import 'package:drop_core/drop_core.dart';

class FirstOrNullStateAppwriteQueryRequestReducer
    extends AppwriteQueryRequestReducer<FirstOrNullStateQueryRequest, State?> {
  FirstOrNullStateAppwriteQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<State?> reduce(
    FirstOrNullStateQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) async {
    appwriteQuery = appwriteQuery.withQuery(appwrite.Query.limit(1));

    final documents = await appwriteQuery.databases.listDocuments(
      databaseId: AppwriteCloudRepository.defaultDatabaseId,
      collectionId: appwriteQuery.collectionId,
      queries: appwriteQuery.queries,
    );

    final state = documents.documents.map(getStateFromDocument).firstOrNull;
    if (state != null) {
      onStateRetrieved?.call(state);
    }

    return state;
  }

  @override
  Stream<State?> reduceX(
    FirstOrNullStateQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    Function(State state)? onStateRetrieved,
  }) {
    throw Exception('Stream of documents from a query is not supported.');
  }
}

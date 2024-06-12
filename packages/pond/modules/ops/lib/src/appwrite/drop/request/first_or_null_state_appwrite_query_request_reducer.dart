import 'dart:async';

import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_cloud_repository.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_request_reducer.dart';

class FirstOrNullStateAppwriteQueryRequestReducer
    extends AppwriteQueryRequestReducer<FirstOrNullStateQueryRequest, State?> {
  FirstOrNullStateAppwriteQueryRequestReducer({required super.dropContext, super.inferredType});

  @override
  Future<State?> reduce(
    FirstOrNullStateQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) async {
    appwriteQuery = appwriteQuery.withQuery(appwrite.Query.limit(1));

    final documents = await appwriteQuery.databases.listDocuments(
      databaseId: AppwriteCloudRepository.defaultDatabaseId,
      collectionId: appwriteQuery.collectionId,
      queries: appwriteQuery.queries,
    );

    final state = documents.documents.map(getStateFromDocument).firstOrNull;
    if (state != null) {
      await onStateRetrieved?.call(state);
    }

    return state;
  }

  @override
  Stream<State?> reduceX(
    FirstOrNullStateQueryRequest queryRequest,
    AppwriteQuery appwriteQuery, {
    FutureOr Function(State state)? onStateRetrieved,
  }) {
    throw Exception('Stream of documents from a query is not supported.');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/with_resolver_query_executor.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'reducer/query/firestore_from_query_reducer.dart';
import 'reducer/query/firestore_order_by_query_reducer.dart';
import 'reducer/query/firestore_where_query_reducer.dart';
import 'reducer/query/firestore_without_cache_query_reducer.dart';
import 'reducer/request/abstract_firestore_query_request_reducer.dart';
import 'reducer/request/firestore_all_query_request_reducer.dart';
import 'reducer/request/firestore_first_query_request_reducer.dart';
import 'reducer/request/firestore_paginate_query_request_reducer.dart';
import 'reducer/request/firestore_without_cache_query_request_reducer.dart';

class FirestoreQueryExecutor with WithResolverQueryExecutor<firestore.Query> implements QueryExecutor {
  final String collectionPath;
  final void Function(Entity entity) onEntityInflated;
  final Type? inferredType;

  FirestoreQueryExecutor({required this.collectionPath, required this.onEntityInflated, this.inferredType});

  List<AbstractQueryReducer<Query, firestore.Query>> getQueryReducers(QueryRequest queryRequest) => [
        FirestoreFromQueryReducer(
          collectionPath: collectionPath,
          inferredType: inferredType,
        ),
        FirestoreWhereQueryReducer(),
        FirestoreOrderByQueryReducer(),
        FirestoreWithoutCacheQueryReducer(),
      ];

  List<AbstractFirestoreQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic>>
      getQueryRequestReducers<R extends Record>() => [
            FirestoreAllQueryRequestReducer<R>(inferredType: inferredType, onEntityInflated: onEntityInflated),
            FirestoreFirstOrNullQueryRequestReducer<R>(inferredType: inferredType, onEntityInflated: onEntityInflated),
            FirestorePaginateQueryRequestReducer<R>(inferredType: inferredType, onEntityInflated: onEntityInflated),
            FirestoreWithoutCacheQueryRequestReducer<R>(
                queryRequestReducerResolverGetter: () => getQueryRequestReducerResolver()),
          ];
}
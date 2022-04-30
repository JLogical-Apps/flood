import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_firestore_query_request_reducer.dart';

class FirestoreWithoutCacheQueryRequestReducer<R extends Record>
    extends AbstractFirestoreQueryRequestReducer<WithoutCacheQueryRequest<R, dynamic>, R, dynamic> {
  final Resolver<QueryRequest<R, dynamic>,
          AbstractQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, firestore.Query>>
      Function() queryRequestReducerResolverGetter;

  FirestoreWithoutCacheQueryRequestReducer({required this.queryRequestReducerResolverGetter});

  @override
  Future<dynamic> reduce({
    required firestore.Query accumulation,
    required WithoutCacheQueryRequest<R, dynamic> queryRequest,
  }) async {
    return queryRequestReducerResolverGetter().resolve(queryRequest.queryRequest).reduce(
          accumulation: accumulation,
          queryRequest: queryRequest.queryRequest,
        );
  }
}

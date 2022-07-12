import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_sync_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalWithoutCacheQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<WithoutCacheQueryRequest<R, dynamic>, R, dynamic> {
  final Resolver<QueryRequest<R, dynamic>,
          AbstractSyncQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, Iterable<State>>>
      Function() queryRequestReducerResolverGetter;

  LocalWithoutCacheQueryRequestReducer({required this.queryRequestReducerResolverGetter});

  @override
  dynamic reduceSync({
    required Iterable<State> accumulation,
    required WithoutCacheQueryRequest<R, dynamic> queryRequest,
  }) {
    return queryRequestReducerResolverGetter().resolve(queryRequest.queryRequest).reduceSync(
          accumulation: accumulation,
          queryRequest: queryRequest.queryRequest,
        );
  }

  @override
  Future<void> reduce({
    required Iterable<State> accumulation,
    required WithoutCacheQueryRequest<R, dynamic> queryRequest,
  }) async {
    return await queryRequestReducerResolverGetter().resolve(queryRequest.queryRequest).reduce(
          accumulation: accumulation,
          queryRequest: queryRequest.queryRequest,
        );
  }
}

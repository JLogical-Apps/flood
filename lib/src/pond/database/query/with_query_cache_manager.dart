import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';

mixin WithQueryCacheManager {
  /// Queries that have been executed already.
  final Set<Query> executedQueries = <Query>{};

  /// If a similar query request hasn't been run at all yet, force [queryRequest] to be run without cache.
  QueryRequest<R, T> modifiedWithoutCacheIfNeeded<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    Query query = queryRequest.query;
    if (query is WithoutCacheQuery<R>) {
      query = query.parent!;
    }

    final added = executedQueries.add(query);
    if (added && !queryRequest.isWithoutCache()) {
      queryRequest = queryRequest.withoutCache();
    }

    return queryRequest;
  }
}

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';

mixin WithQueryCacheManager {
  /// Queries that have been executed already.
  final Set<Query> _executedQueries = <Query>{};

  /// Returns whether the query has been executed before.
  bool hasBeenRunBefore<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    final query = _getQueryFromQueryRequest(queryRequest);

    return _executedQueries.contains(query);
  }

  void markHasBeenRun(QueryRequest queryRequest) {
    final query = _getQueryFromQueryRequest(queryRequest);

    _executedQueries.add(query);
  }

  /// If a similar query request hasn't been run at all yet, force [queryRequest] to be run without cache.
  QueryRequest<R, T> modifiedWithoutCacheIfNeeded<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    final query = _getQueryFromQueryRequest(queryRequest);

    final added = _executedQueries.add(query);
    if (added && !queryRequest.isWithoutCache()) {
      queryRequest = queryRequest.withoutCache();
    }

    return queryRequest;
  }

  Query<R> _getQueryFromQueryRequest<R extends Record>(QueryRequest<R, dynamic> queryRequest) {
    Query query = queryRequest.query;
    if (query is WithoutCacheQuery<R>) {
      query = query.parent!;
    }

    return query as Query<R>;
  }
}

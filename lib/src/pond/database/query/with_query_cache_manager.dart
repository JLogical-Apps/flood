import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';

mixin WithQueryCacheManager {
  /// Queries that have been executed already.
  final Set<QueryRequest> _executedQueryRequests = <QueryRequest>{};

  /// Returns whether the query has been executed before.
  bool hasBeenRunBefore<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return _executedQueryRequests.any((qr) => qr.equalsIgnoringCache(queryRequest));
  }

  void markHasBeenRun(QueryRequest queryRequest) {
    if (queryRequest is WithoutCacheQueryRequest) {
      queryRequest = queryRequest.queryRequest;
    }

    _executedQueryRequests.add(queryRequest);
  }
}

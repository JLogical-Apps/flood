import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';

import '../../query/request/query_request.dart';
import '../../record/record.dart';

mixin WithQueryCacheManager {
  /// Queries that have been executed already.
  final Set<QueryRequest> executedQueryRequests = <QueryRequest>{};

  /// Returns whether the query has been executed before.
  bool hasBeenRunBefore<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return executedQueryRequests.any((qr) => qr.containsOrEquals(queryRequest));
  }

  void markHasBeenRun(QueryRequest queryRequest) {
    if (queryRequest is WithoutCacheQueryRequest) {
      queryRequest = queryRequest.queryRequest;
    }

    executedQueryRequests.add(queryRequest);
  }
}

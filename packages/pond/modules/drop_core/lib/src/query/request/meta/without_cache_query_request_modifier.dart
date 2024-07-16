import 'package:drop_core/src/query/request/meta/query_request_modifier.dart';
import 'package:drop_core/src/query/request/without_cache_query_request.dart';

class WithoutCacheQueryRequestModifier extends QueryRequestMetaModifier<WithoutCacheQueryRequest> {
  @override
  bool isWithoutCache(WithoutCacheQueryRequest queryRequest) {
    return true;
  }
}

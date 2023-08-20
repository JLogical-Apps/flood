import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
import 'package:drop_core/src/query/request/without_cache_query_request.dart';

class WithoutCacheQueryRequestModifier extends QueryRequestModifier<WithoutCacheQueryRequest> {
  @override
  bool getIsWithoutCache(WithoutCacheQueryRequest queryRequest) {
    return true;
  }
}

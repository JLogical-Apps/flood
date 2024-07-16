import 'package:drop_core/src/query/request/meta/query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';

class WrapperQueryRequestModifier extends QueryRequestMetaModifier<QueryRequestWrapper> {
  @override
  bool isWithoutCache(QueryRequestWrapper queryRequest) {
    return QueryRequestMetaModifier.getMetaModifierOrNull(queryRequest.queryRequest)
            ?.isWithoutCache(queryRequest.queryRequest) ??
        false;
  }

  @override
  String? getSingleDocumentId(QueryRequestWrapper queryRequest) {
    return QueryRequestMetaModifier.getMetaModifierOrNull(queryRequest.queryRequest)
        ?.getSingleDocumentId(queryRequest.queryRequest);
  }
}

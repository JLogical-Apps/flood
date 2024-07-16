import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/meta/query_request_modifier.dart';

class MapQueryRequestModifier extends QueryRequestMetaModifier<MapQueryRequest> {
  @override
  bool isWithoutCache(MapQueryRequest queryRequest) {
    final sourceQueryRequest = queryRequest.sourceQueryRequest;
    return QueryRequestMetaModifier.getMetaModifierOrNull(sourceQueryRequest)?.isWithoutCache(sourceQueryRequest) ??
        false;
  }

  @override
  String? getSingleDocumentId(MapQueryRequest queryRequest) {
    final sourceQueryRequest = queryRequest.sourceQueryRequest;
    return QueryRequestMetaModifier.getMetaModifierOrNull(sourceQueryRequest)?.getSingleDocumentId(sourceQueryRequest);
  }
}

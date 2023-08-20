import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';

class MapQueryRequestModifier extends QueryRequestModifier<MapQueryRequest> {
  final QueryRequestModifier? Function(QueryRequest queryRequest) queryRequestModifierGetter;

  MapQueryRequestModifier({required this.queryRequestModifierGetter});

  @override
  bool getIsWithoutCache(MapQueryRequest queryRequest) {
    final sourceQueryRequest = queryRequest.sourceQueryRequest;
    return queryRequestModifierGetter(sourceQueryRequest)?.getIsWithoutCache(sourceQueryRequest) ?? false;
  }
}

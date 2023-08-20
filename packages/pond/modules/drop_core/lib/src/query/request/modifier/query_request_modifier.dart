import 'package:drop_core/src/query/request/modifier/map_query_request_modifier.dart';
import 'package:drop_core/src/query/request/modifier/without_cache_query_request_modifier.dart';
import 'package:drop_core/src/query/request/modifier/wrapper_query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:utils_core/utils_core.dart';

abstract class QueryRequestModifier<QR extends QueryRequest> with IsTypedModifier<QR, QueryRequest> {
  bool getIsWithoutCache(QR queryRequest) {
    return false;
  }

  static final queryRequestModifierResolver = ModifierResolver<QueryRequestModifier, QueryRequest>(modifiers: [
    WithoutCacheQueryRequestModifier(),
    WrapperQueryRequestModifier(queryRequestModifierGetter: getQueryRequestModifier),
    MapQueryRequestModifier(queryRequestModifierGetter: getQueryRequestModifier),
  ]);

  static QueryRequestModifier? getQueryRequestModifier(QueryRequest queryRequest) =>
      queryRequestModifierResolver.resolveOrNull(queryRequest);

  static bool findIsWithoutCache(QueryRequest queryRequest) {
    return queryRequestModifierResolver.resolveOrNull(queryRequest)?.getIsWithoutCache(queryRequest) ?? false;
  }
}

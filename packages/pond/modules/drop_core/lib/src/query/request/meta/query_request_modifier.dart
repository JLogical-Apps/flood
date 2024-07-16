import 'package:drop_core/src/query/request/meta/first_or_null_state_query_request_modifier.dart';
import 'package:drop_core/src/query/request/meta/map_query_request_modifier.dart';
import 'package:drop_core/src/query/request/meta/without_cache_query_request_modifier.dart';
import 'package:drop_core/src/query/request/meta/wrapper_query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:utils_core/utils_core.dart';

abstract class QueryRequestMetaModifier<QR extends QueryRequest> with IsTypedModifier<QR, QueryRequest> {
  bool isWithoutCache(QR queryRequest) {
    return false;
  }

  String? getSingleDocumentId(QR queryRequest) {
    return null;
  }

  static final queryRequestModifierResolver = ModifierResolver<QueryRequestMetaModifier, QueryRequest>(modifiers: [
    WithoutCacheQueryRequestModifier(),
    FirstOrNullStateQueryRequestModifier(),
    WrapperQueryRequestModifier(),
    MapQueryRequestModifier(),
  ]);

  static QueryRequestMetaModifier? getMetaModifierOrNull(QueryRequest queryRequest) =>
      queryRequestModifierResolver.resolveOrNull(queryRequest);

  static QueryRequestMetaModifier getMetaModifier(QueryRequest queryRequest) =>
      queryRequestModifierResolver.resolve(queryRequest);

  static bool findIsWithoutCache(QueryRequest queryRequest) =>
      getMetaModifierOrNull(queryRequest)?.isWithoutCache(queryRequest) ?? false;

  static String? findSingleDocumentId(QueryRequest queryRequest) =>
      getMetaModifierOrNull(queryRequest)?.getSingleDocumentId(queryRequest);
}

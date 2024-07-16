import 'package:drop_core/src/query/meta/where_query_modifier.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:utils_core/utils_core.dart';

abstract class QueryMetaModifier<Q extends Query> with IsTypedModifier<Q, Query> {
  String? getSingleDocumentId(Q query) {
    return null;
  }

  static final queryModifierResolver = ModifierResolver<QueryMetaModifier, Query>(modifiers: [
    WhereQueryModifier(),
  ]);

  static QueryMetaModifier? getMetaModifierOrNull(Query query) => queryModifierResolver.resolveOrNull(query);

  static QueryMetaModifier getMetaModifier(Query query) => queryModifierResolver.resolve(query);

  static String? findSingleDocumentId(Query query) => getMetaModifierOrNull(query)?.getSingleDocumentId(query);
}

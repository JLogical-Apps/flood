import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/meta/query_modifier.dart';

class WhereQueryModifier extends QueryMetaModifier<WhereQuery> {
  @override
  String? getSingleDocumentId(WhereQuery query) {
    if (query.parent is! FromQuery) {
      return null;
    }

    final condition = query.condition;
    if (condition is! EqualsQueryCondition || condition.stateField != State.idField) {
      return null;
    }

    return condition.value;
  }
}

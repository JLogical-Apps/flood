import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/condition/query_condition.dart';

class QueryWhereBuilder {
  final Query query;
  final String stateField;

  const QueryWhereBuilder({required this.query, required this.stateField});

  Query isEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isEqualTo(value));
  }
}

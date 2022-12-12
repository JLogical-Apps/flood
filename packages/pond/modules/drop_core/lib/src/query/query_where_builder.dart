import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/condition/query_condition.dart';

class QueryWhereBuilder {
  final Query query;
  final String stateField;

  const QueryWhereBuilder({required this.query, required this.stateField});

  Query isEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isEqualTo(value));
  }

  Query isGreaterThan(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isGreaterThan(value));
  }

  Query isGreaterThanOrEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isGreaterThanOrEqualTo(value));
  }

  Query isLessThan(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isLessThan(value));
  }

  Query isLessThanOrEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isLessThanOrEqualTo(value));
  }

  Query isNull() {
    return query.whereCondition(QueryCondition.field(stateField).isNull());
  }

  Query isNonNull() {
    return query.whereCondition(QueryCondition.field(stateField).isNonNull());
  }
}

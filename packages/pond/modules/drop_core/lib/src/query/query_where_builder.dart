import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class QueryWhereBuilder<E extends Entity> {
  final Query<E> query;
  final String stateField;

  const QueryWhereBuilder({required this.query, required this.stateField});

  Query<E> isEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isEqualTo(value));
  }

  Query<E> isGreaterThan(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isGreaterThan(value));
  }

  Query<E> isGreaterThanOrEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isGreaterThanOrEqualTo(value));
  }

  Query<E> isLessThan(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isLessThan(value));
  }

  Query<E> isLessThanOrEqualTo(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).isLessThanOrEqualTo(value));
  }

  Query<E> isNull() {
    return query.whereCondition(QueryCondition.field(stateField).isNull());
  }

  Query<E> isNonNull() {
    return query.whereCondition(QueryCondition.field(stateField).isNonNull());
  }

  Query<E> contains(dynamic value) {
    return query.whereCondition(QueryCondition.field(stateField).contains(value));
  }

  Query<E> isIn(List values) {
    return query.whereCondition(QueryCondition.field(stateField).isIn(values));
  }
}

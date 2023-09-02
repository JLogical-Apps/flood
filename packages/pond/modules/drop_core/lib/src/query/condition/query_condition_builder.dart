import 'package:drop_core/src/query/condition/contains_query_condition.dart';
import 'package:drop_core/src/query/condition/equals_query_condition.dart';
import 'package:drop_core/src/query/condition/is_greater_than_or_equal_to_query_condition.dart';
import 'package:drop_core/src/query/condition/is_greater_than_query_condition.dart';
import 'package:drop_core/src/query/condition/is_less_than_or_equal_to_query_condition.dart';
import 'package:drop_core/src/query/condition/is_less_than_query_condition.dart';
import 'package:drop_core/src/query/condition/is_non_null_query_condition.dart';
import 'package:drop_core/src/query/condition/is_null_query_condition.dart';

class QueryConditionBuilder {
  final String stateField;

  const QueryConditionBuilder({required this.stateField});

  EqualsQueryCondition isEqualTo(dynamic value) {
    return EqualsQueryCondition(stateField: stateField, value: value);
  }

  IsGreaterThanQueryCondition isGreaterThan(dynamic value) {
    return IsGreaterThanQueryCondition(stateField: stateField, value: value);
  }

  IsGreaterThanOrEqualToQueryCondition isGreaterThanOrEqualTo(dynamic value) {
    return IsGreaterThanOrEqualToQueryCondition(stateField: stateField, value: value);
  }

  IsLessThanQueryCondition isLessThan(dynamic value) {
    return IsLessThanQueryCondition(stateField: stateField, value: value);
  }

  IsLessThanOrEqualToQueryCondition isLessThanOrEqualTo(dynamic value) {
    return IsLessThanOrEqualToQueryCondition(stateField: stateField, value: value);
  }

  IsNullQueryCondition isNull() {
    return IsNullQueryCondition(stateField: stateField);
  }

  IsNonNullQueryCondition isNonNull() {
    return IsNonNullQueryCondition(stateField: stateField);
  }

  ContainsQueryCondition contains(dynamic value) {
    return ContainsQueryCondition(stateField: stateField, value: value);
  }
}

import 'package:drop_core/src/query/condition/equals_query_condition.dart';

class QueryConditionBuilder {
  final String stateField;

  const QueryConditionBuilder({required this.stateField});

  EqualsQueryCondition isEqualTo(dynamic value) {
    return EqualsQueryCondition(stateField: stateField, value: value);
  }
}

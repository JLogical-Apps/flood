import 'package:drop_core/src/query/condition/not_equals_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class NotEqualsStateQueryConditionReducer extends StateQueryConditionReducer<NotEqualsQueryCondition> {
  @override
  bool valueMatches(NotEqualsQueryCondition queryCondition, dynamic stateValue) {
    final (comparisonValue, value) = convertValues(queryCondition.value, stateValue);
    return comparisonValue != value;
  }
}

import 'package:drop_core/src/query/condition/is_less_than_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class IsLessThanStateQueryConditionReducer extends StateQueryConditionReducer<IsLessThanQueryCondition> {
  @override
  bool valueMatches(IsLessThanQueryCondition queryCondition, dynamic stateValue) {
    final (comparisonValue, value) = convertValues(queryCondition.value, stateValue);
    if (value == null) {
      return false;
    }
    return value < comparisonValue;
  }
}

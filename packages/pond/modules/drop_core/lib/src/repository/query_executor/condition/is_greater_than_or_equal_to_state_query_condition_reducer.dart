import 'package:drop_core/src/query/condition/is_greater_than_or_equal_to_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class IsGreaterThanOrEqualToStateQueryConditionReducer
    extends StateQueryConditionReducer<IsGreaterThanOrEqualToQueryCondition> {
  @override
  bool valueMatches(IsGreaterThanOrEqualToQueryCondition queryCondition, dynamic stateValue) {
    if (stateValue == null) {
      return false;
    }
    return stateValue >= queryCondition.value;
  }
}

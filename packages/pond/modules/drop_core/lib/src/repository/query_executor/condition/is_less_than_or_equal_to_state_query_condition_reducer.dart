import 'package:drop_core/src/query/condition/is_less_than_or_equal_to_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class IsLessThanOrEqualToStateQueryConditionReducer
    extends StateQueryConditionReducer<IsLessThanOrEqualToQueryCondition> {
  @override
  bool valueMatches(IsLessThanOrEqualToQueryCondition queryCondition, dynamic stateValue) {
    if (stateValue == null) {
      return false;
    }
    return stateValue <= queryCondition.value;
  }
}

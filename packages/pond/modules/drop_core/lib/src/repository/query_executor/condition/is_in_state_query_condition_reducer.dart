import 'package:drop_core/src/query/condition/is_in_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class IsInStateQueryConditionReducer extends StateQueryConditionReducer<IsInQueryCondition> {
  @override
  bool valueMatches(IsInQueryCondition queryCondition, dynamic stateValue) {
    return queryCondition.values.contains(stateValue);
  }
}

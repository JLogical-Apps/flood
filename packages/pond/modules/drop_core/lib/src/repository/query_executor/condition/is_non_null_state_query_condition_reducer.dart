import 'package:drop_core/src/query/condition/is_non_null_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class IsNonNullStateQueryConditionReducer extends StateQueryConditionReducer<IsNonNullQueryCondition> {
  @override
  bool valueMatches(IsNonNullQueryCondition queryCondition, dynamic stateValue) {
    return stateValue != null;
  }
}

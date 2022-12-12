import 'package:drop_core/src/query/condition/is_null_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class IsNullStateQueryConditionReducer extends StateQueryConditionReducer<IsNullQueryCondition> {
  @override
  bool valueMatches(IsNullQueryCondition queryCondition, dynamic stateValue) {
    return stateValue == null;
  }
}

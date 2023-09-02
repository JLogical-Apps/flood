import 'package:drop_core/src/query/condition/equals_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class EqualsStateQueryConditionReducer extends StateQueryConditionReducer<EqualsQueryCondition> {
  @override
  bool valueMatches(EqualsQueryCondition queryCondition, dynamic stateValue) {
    return queryCondition.value == stateValue;
  }
}

import 'package:drop_core/src/query/condition/contains_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class ContainsStateQueryConditionReducer extends StateQueryConditionReducer<ContainsQueryCondition> {
  @override
  bool valueMatches(ContainsQueryCondition queryCondition, dynamic stateValue) {
    if (stateValue is! List) {
      return false;
    }

    return stateValue.contains(queryCondition.value);
  }
}

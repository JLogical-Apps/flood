import 'package:drop_core/src/query/condition/contains_any_query_condition.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';

class ContainsAnyStateQueryConditionReducer extends StateQueryConditionReducer<ContainsAnyQueryCondition> {
  @override
  bool valueMatches(ContainsAnyQueryCondition queryCondition, dynamic stateValue) {
    if (stateValue is! List) {
      return false;
    }

    return stateValue.any((element) => queryCondition.values.contains(element));
  }
}

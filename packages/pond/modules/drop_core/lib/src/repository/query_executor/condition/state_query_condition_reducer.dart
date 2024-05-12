import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class StateQueryConditionReducer<QC extends QueryCondition> extends Modifier<QueryCondition> {
  @override
  bool shouldModify(QueryCondition input) {
    return input is QC;
  }

  Iterable<State> reduce(QC queryCondition, Iterable<State> currentStates) {
    return currentStates.where((state) => valueMatches(queryCondition, state[queryCondition.stateField]));
  }

  bool valueMatches(QC queryCondition, dynamic stateValue);

  (dynamic, dynamic) convertValues(dynamic comparisonValue, dynamic stateValue) {
    if (comparisonValue is DateTime) {
      comparisonValue = comparisonValue.millisecondsSinceEpoch;
      if (stateValue is String) {
        stateValue = DateTime.parse(stateValue).millisecondsSinceEpoch;
      } else if (stateValue is DateTime) {
        stateValue = stateValue.millisecondsSinceEpoch;
      }
    }

    return (comparisonValue, stateValue);
  }
}

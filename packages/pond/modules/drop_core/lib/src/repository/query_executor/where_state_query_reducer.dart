import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/where_query.dart';
import 'package:drop_core/src/repository/query_executor/condition/equals_state_query_condition_reducer.dart';
import 'package:drop_core/src/repository/query_executor/condition/is_greater_than_or_equal_to_state_query_condition_reducer.dart';
import 'package:drop_core/src/repository/query_executor/condition/is_greater_than_state_query_condition_reducer.dart';
import 'package:drop_core/src/repository/query_executor/condition/is_less_than_or_equal_to_state_query_condition_reducer.dart';
import 'package:drop_core/src/repository/query_executor/condition/is_less_than_state_query_condition_reducer.dart';
import 'package:drop_core/src/repository/query_executor/condition/state_query_condition_reducer.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class WhereStateQueryReducer extends StateQueryReducer<WhereQuery> {
  WrapperResolver<StateQueryConditionReducer, QueryCondition> getQueryReducerResolver() => WrapperResolver(wrappers: [
        EqualsStateQueryConditionReducer(),
        IsGreaterThanStateQueryConditionReducer(),
        IsGreaterThanOrEqualToStateQueryConditionReducer(),
        IsLessThanStateQueryConditionReducer(),
        IsLessThanOrEqualToStateQueryConditionReducer(),
      ]);

  @override
  Iterable<State> reduce(WhereQuery query, Iterable<State> currentStates) {
    return getQueryReducerResolver().resolve(query.condition).reduce(query.condition, currentStates);
  }
}

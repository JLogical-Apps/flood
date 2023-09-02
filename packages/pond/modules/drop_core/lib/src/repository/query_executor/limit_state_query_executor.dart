import 'package:drop_core/src/query/limit_query.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class LimitStateQueryReducer extends StateQueryReducer<LimitQuery> {
  @override
  Iterable<State> reduce(LimitQuery query, Iterable<State> currentStates) {
    return currentStates.take(query.limit);
  }
}

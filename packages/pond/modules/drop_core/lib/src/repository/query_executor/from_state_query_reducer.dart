import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class FromStateQueryReducer<E extends Entity> extends StateQueryReducer<FromQuery> {
  @override
  Iterable<State> reduce(FromQuery query, Iterable<State> currentStates) {
    return currentStates.where((state) => state.type == '$E');
  }
}

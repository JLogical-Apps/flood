import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class FromStateQueryReducer extends StateQueryReducer {
  @override
  bool shouldWrap<E extends Entity>(Query<E> query) {
    return query is FromQuery<E>;
  }

  @override
  Iterable<State> reduce<E extends Entity>(Query<E> query, Iterable<State> currentStates) {
    return currentStates.where((state) => state.type == '$E');
  }
}

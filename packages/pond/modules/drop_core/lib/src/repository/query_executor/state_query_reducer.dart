import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class StateQueryReducer<Q extends Query> extends Wrapper<Query> {
  @override
  bool shouldWrap(Query input) {
    return input is Q;
  }

  Iterable<State> reduce(Q query, Iterable<State> currentStates);
}

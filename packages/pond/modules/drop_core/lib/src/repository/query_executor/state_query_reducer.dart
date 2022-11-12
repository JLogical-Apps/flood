import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

abstract class StateQueryReducer {
  bool shouldWrap<E extends Entity>(Query<E> query);

  Iterable<State> reduce<E extends Entity>(Query<E> query, Iterable<State> currentStates);
}

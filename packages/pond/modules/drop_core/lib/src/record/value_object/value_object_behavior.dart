import 'package:drop_core/src/state/state.dart';

abstract class ValueObjectBehavior {
  void fromState(State state) {}

  State modifyState(State state) {
    return state;
  }

  State modifyStateUnsafe(State state) {
    return modifyState(state);
  }
}

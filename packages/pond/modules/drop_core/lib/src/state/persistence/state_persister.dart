import 'package:drop_core/src/state/state.dart';

abstract class StatePersister<T> {
  T persist(State state);

  State inflate(T persisted);
}

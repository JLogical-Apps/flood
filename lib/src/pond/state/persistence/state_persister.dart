import 'package:jlogical_utils/src/pond/state/state.dart';

abstract class StatePersister<T> {
  T persist(State state);

  State inflate(T persisted);
}

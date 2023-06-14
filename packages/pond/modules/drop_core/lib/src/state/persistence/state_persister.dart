import 'package:drop_core/src/state/persistence/json_state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

abstract class StatePersister<T> {
  T persist(State state);

  State inflate(T persisted);

  static JsonStatePersister json({required RuntimeType Function(String typeName) runtimeTypeGetter}) =>
      JsonStatePersister(runtimeTypeGetter: runtimeTypeGetter);
}

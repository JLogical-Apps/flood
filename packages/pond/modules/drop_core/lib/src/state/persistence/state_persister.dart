import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/state/persistence/json_state_persister.dart';
import 'package:drop_core/src/state/persistence/state_state_persister.dart';

abstract class StatePersister<T> {
  T persist(State state);

  State inflate(T persisted);

  static JsonStatePersister json({required DropCoreContext context}) => JsonStatePersister(context: context);

  static StateStatePersister state({required DropCoreContext context}) => StateStatePersister(context: context);
}

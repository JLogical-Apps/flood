import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/state/persistence/json_state_persister.dart';
import 'package:drop_core/src/state/persistence/json_string_state_persister.dart';
import 'package:drop_core/src/state/persistence/map_state_persister.dart';
import 'package:drop_core/src/state/persistence/state_state_persister.dart';

abstract class StatePersister<T> {
  T persist(State state);

  State inflate(T persisted);

  static JsonStringStatePersister jsonString({required DropCoreContext context}) =>
      JsonStringStatePersister(context: context);

  static JsonStatePersister json({required DropCoreContext context}) => JsonStatePersister(context: context);

  static StateStatePersister state({required DropCoreContext context}) => StateStatePersister(context: context);
}

extension StatePersisterExtension<T> on StatePersister<T> {
  MapStatePersister<T, R> map<R>({
    required R Function(T data) persistMapper,
    required T Function(R persisted) inflateMapper,
  }) {
    return MapStatePersister(sourceStatePersister: this, persistMapper: persistMapper, inflateMapper: inflateMapper);
  }
}

mixin IsStatePersister<T> implements StatePersister<T> {}

abstract class StatePersisterWrapper<T> implements StatePersister<T> {
  StatePersister<T> get statePersister;
}

mixin IsStatePersisterWrapper<T> implements StatePersisterWrapper<T> {
  @override
  T persist(State state) => statePersister.persist(state);

  @override
  State inflate(T persisted) => statePersister.inflate(persisted);
}

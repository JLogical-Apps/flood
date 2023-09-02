import 'package:drop_core/drop_core.dart';

class MapStatePersister<T, R> with IsStatePersister<R> {
  final StatePersister<T> sourceStatePersister;

  final R Function(T data) persistMapper;
  final T Function(R persisted) inflateMapper;

  MapStatePersister({required this.sourceStatePersister, required this.persistMapper, required this.inflateMapper});

  @override
  R persist(State state) {
    final sourcePersisted = sourceStatePersister.persist(state);
    return persistMapper(sourcePersisted);
  }

  @override
  State inflate(R persisted) {
    final mappedInflated = inflateMapper(persisted);
    return sourceStatePersister.inflate(mappedInflated);
  }
}

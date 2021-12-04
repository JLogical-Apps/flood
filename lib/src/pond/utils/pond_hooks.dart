import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

FutureValue<A>? useAggregate<A extends Aggregate>(String? id) {
  final valueX = useMemoized(() {
    if (id == null) {
      return null;
    }

    final appContext = AppContext.global;

    final entityType = appContext.getEntityTypeFromAggregate(A);
    final repository = appContext.getRepositoryRuntime(entityType);

    final entityX = repository.getX(id);

    return entityX.mapWithValue(
        (maybeEntity) => maybeEntity.mapIfPresent((entity) => appContext.constructAggregateFromEntity<A>(entity)));
  }, [id]);

  return useValueStreamOrNull(valueX);
}

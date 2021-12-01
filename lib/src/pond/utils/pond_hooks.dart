import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

FutureValue<A>? useAggregate<A extends Aggregate>(String? id) {
  final valueX = useMemoized(() {
    if(id == null) {
      return null;
    }

    final appContext = AppContext.global;
    final database = appContext.database;

    final entityType = appContext.getEntityTypeFromAggregate<A>();
    final repository = database.getRepositoryRuntime(entityType);

    final entityX = repository.getX(id);

    return entityX.mapWithValue((maybeEntity) =>
        maybeEntity.mapIfPresent((entity) => appContext.constructAggregateFromEntityRuntime(A, entity) as A));
  }, [id]);

  return useValueStreamOrNull(valueX);
}

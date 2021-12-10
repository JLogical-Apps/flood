import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/utils/query_controller.dart';

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

QueryController<R, T> useQuery<R extends Record, T>(AbstractQueryRequest<R, T> queryRequest) {
  final queryController = useMemoized(() => QueryController(queryRequest: queryRequest));
  useModel(queryController.model);
  return queryController;
}

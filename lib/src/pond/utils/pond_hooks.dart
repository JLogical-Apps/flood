import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/pond/utils/entity_controller.dart';
import 'package:jlogical_utils/src/pond/utils/query_controller.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../utils/export.dart';
import '../query/executor/query_executor_x.dart';
import '../query/query.dart';
import '../query/request/query_request.dart';
import '../record/entity.dart';
import '../record/record.dart';
import '../record/singleton.dart';
import '../record/value_object.dart';

EntityController<E>? useEntityOrNull<E extends Entity>(String? id) {
  final entityController = useMemoized(() => id.mapIfNonNull((id) => EntityController<E>(entityId: id)), [id]);
  useModelOrNull(entityController?.model);
  return entityController;
}

EntityController<E> useEntity<E extends Entity>(String id) {
  return useEntityOrNull(id)!;
}

List<EntityController<E>> useEntities<E extends Entity>(List<String> ids) {
  final queryControllers = useMemoized(
    () => ids.map((id) => EntityController<E>(entityId: id)).toList(),
    ids,
  );
  useModels(queryControllers.map((queryController) => queryController.model).toList());
  return queryControllers;
}

QueryController<R, T>? useQueryOrNull<R extends Record, T>(
  QueryRequest<R, T>? queryRequest, {
  QueryExecutorX? queryExecutorX,
}) {
  final queryController = useMemoized(
    () => queryRequest
        .mapIfNonNull((queryRequest) => QueryController(queryRequest: queryRequest, queryExecutorX: queryExecutorX)),
    [queryRequest],
  );
  useModelOrNull(queryController?.model);
  return queryController;
}

QueryController<R, T> useQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {QueryExecutorX? queryExecutorX}) {
  return useQueryOrNull(queryRequest, queryExecutorX: queryExecutorX)!;
}

List<QueryController<R, T>> useQueries<R extends Record, T>(List<QueryRequest<R, T>> queryRequests) {
  final queryControllers = useMemoized(
    () => queryRequests.map((queryRequest) => QueryController(queryRequest: queryRequest)).toList(),
    queryRequests,
  );
  useModels(queryControllers.map((queryController) => queryController.model).toList());
  return queryControllers;
}

QueryController<E, E?> useSingleton<E extends Entity<V>, V extends ValueObject>() {
  return useQuery(Query.from<E>().firstOrNull().map((value) => value ?? Singleton.createDefault<E, V>()));
}

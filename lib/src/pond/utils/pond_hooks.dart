import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/pond/utils/entity_controller.dart';
import 'package:jlogical_utils/src/pond/utils/query_controller.dart';

import '../../utils/export.dart';
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

QueryController<R, T>? useQueryOrNull<R extends Record, T>(QueryRequest<R, T>? queryRequest) {
  final queryController = useMemoized(
    () => queryRequest.mapIfNonNull((queryRequest) => QueryController(queryRequest: queryRequest)),
    [queryRequest],
  );
  useModelOrNull(queryController?.model);
  return queryController;
}

QueryController<R, T> useQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
  return useQueryOrNull(queryRequest)!;
}

QueryController<E, E?> useSingleton<E extends Entity<V>, V extends ValueObject>() {
  return useQuery(Query.from<E>().firstOrNull().map((value) => value ?? Singleton.createDefault<E, V>()));
}

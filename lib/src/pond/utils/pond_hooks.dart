import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/utils/entity_controller.dart';
import 'package:jlogical_utils/src/pond/utils/query_controller.dart';

import 'aggregate_controller.dart';

AggregateController<A, E> useAggregate<A extends Aggregate<E>, E extends Entity>(String id) {
  final aggregateController = useMemoized(() => AggregateController<A, E>(aggregateId: id), [id]);
  useModel(aggregateController.model);
  return aggregateController;
}

EntityController<E> useEntity<E extends Entity>(String id) {
  final entityController = useMemoized(() => EntityController<E>(entityId: id), [id]);
  useModel(entityController.model);
  return entityController;
}

QueryController<R, T> useQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
  final queryController = useMemoized(() => QueryController(queryRequest: queryRequest), [queryRequest]);
  useModel(queryController.model);
  return queryController;
}

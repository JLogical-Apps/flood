import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

class AllStateQueryRequestReducer extends StateQueryRequestReducer<AllQueryRequest, List<Entity>> {
  AllStateQueryRequestReducer({required super.dropContext});

  @override
  List<Entity> reduce(AllQueryRequest<Entity> queryRequest, Iterable<State> states) {
    final entityRuntimeType =
        dropContext.typeContext.getRuntimeTypeRuntime(queryRequest.entityType) as RuntimeType<Entity>;
    final entities = entityRuntimeType.createList();
    for (final state in states) {
      final entity = entityRuntimeType.createInstance();
      entity.id = state.id;

      final valueObject =
          dropContext.typeContext.getRuntimeTypeRuntime(entity.valueObjectType).createInstance() as ValueObject;
      valueObject.state = state;

      entity.value = valueObject;
      entities.add(entity);
    }
    return entities;
  }
}

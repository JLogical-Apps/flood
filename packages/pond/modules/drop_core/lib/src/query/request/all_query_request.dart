import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/map_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

class AllQueryRequest<E extends Entity> with IsMapQueryRequest<List<State>, List<E>> {
  @override
  final QueryRequest<List<State>> sourceQueryRequest;

  AllQueryRequest({required this.sourceQueryRequest});

  @override
  FutureOr<List<E>> doMap(DropCoreContext context, List<State> states) async {
    final entityRuntimeType = context.typeContext.getRuntimeType<E>();
    final entities = entityRuntimeType.createList();
    for (final state in states) {
      final entity = entityRuntimeType.createInstance();
      entity.id = state.id;

      final valueObject =
          context.typeContext.getRuntimeTypeRuntime(entity.valueObjectType).createInstance() as ValueObject;
      valueObject.state = state;

      entity.value = valueObject;
      entities.add(entity);
    }
    return entities;
  }
}

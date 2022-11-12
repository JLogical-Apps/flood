import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

class AllStateQueryRequestReducer extends StateQueryRequestReducer {
  AllStateQueryRequestReducer({required super.dropContext});

  @override
  bool shouldWrap<E extends Entity, T>(QueryRequest<E, T> queryRequest) {
    return queryRequest is AllQueryRequest<E>;
  }

  @override
  T reduce<E extends Entity, T>(QueryRequest<E, T> queryRequest, Iterable<State> states) {
    return states.map((state) {
      final entity = dropContext.typeContext.getRuntimeType<E>().createInstance();
      entity.id = state.id;

      final valueObject =
          dropContext.typeContext.getRuntimeTypeRuntime(entity.valueObjectType).createInstance() as ValueObject;
      valueObject.state = state;

      entity.value = valueObject;
      return entity;
    }).toList() as T;
  }
}

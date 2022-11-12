import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

abstract class StateQueryRequestReducer {
  final DropCoreContext dropContext;

  StateQueryRequestReducer({required this.dropContext});

  bool shouldWrap<E extends Entity, T>(QueryRequest<E, T> queryRequest);

  T reduce<E extends Entity, T>(QueryRequest<E, T> queryRequest, Iterable<State> states);
}

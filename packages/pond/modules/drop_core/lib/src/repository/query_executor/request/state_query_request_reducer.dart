import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class StateQueryRequestReducer<QR extends QueryRequest<E, T>, E extends Entity, T>
    extends Wrapper<QueryRequest> {
  final DropCoreContext dropContext;

  StateQueryRequestReducer({required this.dropContext});

  @override
  bool shouldWrap(QueryRequest input) {
    return input is QR;
  }

  T reduce(QR queryRequest, Iterable<State> states);
}

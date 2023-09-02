import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class StateQueryRequestReducer<QR extends QueryRequest<dynamic, T>, T> extends Modifier<QueryRequest> {
  final DropCoreContext dropContext;

  StateQueryRequestReducer({required this.dropContext});

  @override
  bool shouldModify(QueryRequest input) {
    return input is QR;
  }

  FutureOr<T> reduce(
    QR queryRequest,
    Iterable<State> states, {
    Function(State state)? onStateRetrieved,
  });
}

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/query_executor/from_state_query_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/all_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';

class StateQueryExecutor implements RepositoryQueryExecutor {
  final ValueStream<List<State>> statesX;

  final DropCoreContext dropContext;

  StateQueryExecutor({required this.statesX, required this.dropContext});

  late List<StateQueryReducer> queryReducers = [
    FromStateQueryReducer(),
  ];

  late List<StateQueryRequestReducer> queryRequestReducers = [
    AllStateQueryRequestReducer(dropContext: dropContext),
  ];

  @override
  Future<T> execute<E extends Entity, T>(QueryRequest<E, T> queryRequest) {
    return executeOnStates(queryRequest, statesX.value);
  }

  Future<T> executeOnStates<E extends Entity, T>(QueryRequest<E, T> queryRequest, List<State> states) async {
    final reducedStates = reduceStates(states, queryRequest.query);

    final queryRequestReducer = queryRequestReducers.firstWhere((reducer) => reducer.shouldWrap(queryRequest));
    return queryRequestReducer.reduce(queryRequest, reducedStates);
  }

  Iterable<State> reduceStates<E extends Entity>(Iterable<State> states, Query<E> query) {
    final queryReducer = queryReducers.firstWhere((reducer) => reducer.shouldWrap(query));
    final queryParent = query.parent;
    return queryReducer.reduce(query, queryParent == null ? states : reduceStates(states, queryParent));
  }

  @override
  Stream<T> executeX<E extends Entity, T>(QueryRequest<E, T> queryRequest) {
    return statesX.asyncMap((states) => executeOnStates(queryRequest, states));
  }
}

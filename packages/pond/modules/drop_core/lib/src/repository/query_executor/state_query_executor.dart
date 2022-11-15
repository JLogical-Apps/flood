import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/from_state_query_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/all_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/all_states_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/map_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class StateQueryExecutor implements RepositoryQueryExecutor {
  final ValueStream<List<State>> statesX;

  final DropCoreContext dropContext;

  StateQueryExecutor({required this.statesX, required this.dropContext});

  WrapperResolver<StateQueryReducer, Query> getQueryReducers() => WrapperResolver(wrappers: [
        FromStateQueryReducer(),
      ]);

  WrapperResolver<StateQueryRequestReducer, QueryRequest> getQueryRequestReducers<T>() => WrapperResolver(wrappers: [
        AllStateQueryRequestReducer(dropContext: dropContext),
        AllStatesStateQueryRequestReducer(dropContext: dropContext),
        MapStateQueryRequestReducer(
          dropContext: dropContext,
          queryRequestResolver: <T>(qr, states) async => await resolveForQueryRequest(qr, states),
        )
      ]);

  @override
  Future<T> execute<T>(QueryRequest<T> queryRequest) {
    return executeOnStates(queryRequest, statesX.value);
  }

  Future<T> executeOnStates<T>(QueryRequest<T> queryRequest, List<State> states) async {
    final reducedStates = reduceStates(states, queryRequest.query);
    return await resolveForQueryRequest<T>(queryRequest, reducedStates);
  }

  Future<T> resolveForQueryRequest<T>(QueryRequest<T> queryRequest, Iterable<State> states) async {
    return await getQueryRequestReducers<T>().resolve(queryRequest).reduce(queryRequest, states);
  }

  Iterable<State> reduceStates(Iterable<State> states, Query query) {
    final queryParent = query.parent;
    return getQueryReducers()
        .resolve(query)
        .reduce(query, queryParent == null ? states : reduceStates(states, queryParent));
  }

  @override
  Stream<T> executeX<T>(QueryRequest<T> queryRequest) {
    return statesX.asyncMap((states) => executeOnStates(queryRequest, states));
  }
}

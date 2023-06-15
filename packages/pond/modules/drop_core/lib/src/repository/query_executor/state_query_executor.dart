import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/from_state_query_reducer.dart';
import 'package:drop_core/src/repository/query_executor/order_by_state_query_executor.dart';
import 'package:drop_core/src/repository/query_executor/request/all_states_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/first_or_null_state_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/map_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/paginate_states_state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/request/state_query_request_reducer.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/repository/query_executor/where_state_query_reducer.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class StateQueryExecutor implements RepositoryQueryExecutor {
  final ValueStream<FutureValue<List<State>>> maybeStatesX;

  final CoreDropContext dropContext;

  StateQueryExecutor({required this.maybeStatesX, required this.dropContext});

  StateQueryExecutor.fromStatesX({required ValueStream<List<State>> statesX, required this.dropContext})
      : maybeStatesX = statesX.mapWithValue((value) => FutureValue.loaded(value));

  ModifierResolver<StateQueryReducer, Query> getQueryReducerResolver() => Resolver.fromModifiers([
        FromStateQueryReducer(dropContext: dropContext),
        WhereStateQueryReducer(),
        OrderByStateQueryReducer(),
      ]);

  ModifierResolver<StateQueryRequestReducer, QueryRequest> getQueryRequestReducerResolver<T>() =>
      Resolver.fromModifiers([
        AllStatesStateQueryRequestReducer(dropContext: dropContext),
        FirstOrNullStateStateQueryRequestReducer(dropContext: dropContext),
        MapStateQueryRequestReducer(
          dropContext: dropContext,
          queryRequestResolver: <T>(qr, states, onStateRetrieved) => resolveForQueryRequest(
            qr,
            states,
            onStateRetreived: onStateRetrieved,
          ),
        ),
        PaginateStatesStateQueryRequestReducer(dropContext: dropContext),
      ]);

  @override
  bool handlesQuery(QueryRequest queryRequest) {
    return false;
  }

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) async {
    await maybeStatesX.waitUntil((maybeStates) => maybeStates.isLoaded);
    return await executeOnStates(
      queryRequest,
      maybeStatesX.value.getOrNull()!,
      onStateRetreived: onStateRetreived,
    );
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    return maybeStatesX.asyncMapWithValue(
      (maybeStates) => maybeStates.asyncMap((states) => executeOnStates(queryRequest, states)),
      initialValue: FutureValue.empty(),
    );
  }

  Future<T> executeOnStates<T>(
    QueryRequest<dynamic, T> queryRequest,
    List<State> states, {
    Function(State state)? onStateRetreived,
  }) async {
    final reducedStates = reduceStates(states, queryRequest.query);
    return await resolveForQueryRequest<T>(
      queryRequest,
      reducedStates,
      onStateRetreived: onStateRetreived,
    );
  }

  Future<T> resolveForQueryRequest<T>(
    QueryRequest<dynamic, T> queryRequest,
    Iterable<State> states, {
    Function(State state)? onStateRetreived,
  }) async {
    return await getQueryRequestReducerResolver<T>().resolve(queryRequest).reduce(
          queryRequest,
          states,
          onStateRetrieved: onStateRetreived,
        );
  }

  Iterable<State> reduceStates(Iterable<State> states, Query query) {
    final queryParent = query.parent;
    return getQueryReducerResolver()
        .resolve(query)
        .reduce(query, queryParent == null ? states : reduceStates(states, queryParent));
  }
}

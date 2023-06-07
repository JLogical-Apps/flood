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
  final ValueStream<List<State>> statesX;

  final CoreDropContext dropContext;

  StateQueryExecutor({required this.statesX, required this.dropContext});

  ModifierResolver<StateQueryReducer, Query> getQueryReducerResolver() => ModifierResolver(modifiers: [
        FromStateQueryReducer(dropContext: dropContext),
        WhereStateQueryReducer(),
        OrderByStateQueryReducer(),
      ]);

  ModifierResolver<StateQueryRequestReducer, QueryRequest> getQueryRequestReducerResolver<T>() =>
      ModifierResolver(modifiers: [
        AllStatesStateQueryRequestReducer(dropContext: dropContext),
        FirstOrNullStateStateQueryRequestReducer(dropContext: dropContext),
        MapStateQueryRequestReducer(
          dropContext: dropContext,
          queryRequestResolver: <T>(qr, states) async => await resolveForQueryRequest(qr, states),
        ),
        PaginateStatesStateQueryRequestReducer(dropContext: dropContext),
      ]);

  @override
  bool handlesQuery(QueryRequest queryRequest) {
    return false;
  }

  @override
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest) {
    return executeOnStates(queryRequest, statesX.value);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(QueryRequest<dynamic, T> queryRequest) {
    return statesX.asyncMapWithValue(
      (states) async {
        try {
          return FutureValue.loaded(await executeOnStates(queryRequest, states));
        } catch (e, stackTrace) {
          return FutureValue.error(e, stackTrace);
        }
      },
      initialValue: FutureValue.empty(),
    );
  }

  Future<T> executeOnStates<T>(QueryRequest<dynamic, T> queryRequest, List<State> states) async {
    final reducedStates = reduceStates(states, queryRequest.query);
    return await resolveForQueryRequest<T>(queryRequest, reducedStates);
  }

  Future<T> resolveForQueryRequest<T>(QueryRequest<dynamic, T> queryRequest, Iterable<State> states) async {
    return await getQueryRequestReducerResolver<T>().resolve(queryRequest).reduce(queryRequest, states);
  }

  Iterable<State> reduceStates(Iterable<State> states, Query query) {
    final queryParent = query.parent;
    return getQueryReducerResolver()
        .resolve(query)
        .reduce(query, queryParent == null ? states : reduceStates(states, queryParent));
  }
}

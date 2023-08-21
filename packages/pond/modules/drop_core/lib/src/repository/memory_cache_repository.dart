import 'dart:async';

import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/repository/query_executor/state_query_executor.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class MemoryCacheRepository with IsRepositoryWrapper {
  @override
  late final Repository repository;

  final BehaviorSubject<Map<String, State>> stateByIdX = BehaviorSubject.seeded({});
  final Set<QueryRequest> queriesRun = {};

  MemoryCacheRepository({required Repository sourceRepository}) {
    repository = sourceRepository.withListener(
      onStateRetrieved: (state) => stateByIdX.value = stateByIdX.value.copy()..set(state.id!, state),
    );
  }

  @override
  late final List<CorePondComponentBehavior> behaviors = super.behaviors +
      [
        CorePondComponentBehavior(onReset: (context, _) async {
          stateByIdX.value = {};
          queriesRun.clear();
        }),
      ];

  @override
  late final RepositoryQueryExecutor queryExecutor = MemoryCacheRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = MemoryCacheRepositoryStateHandler(repository: this);
}

class MemoryCacheRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final MemoryCacheRepository repository;

  final BehaviorSubject<Map<QueryRequest, Completer>> _completerByLoadingQueryRequestX = BehaviorSubject.seeded({});

  Map<QueryRequest, Completer> get completerByLoadingQueryRequest => _completerByLoadingQueryRequestX.value;

  MemoryCacheRepositoryQueryExecutor({required this.repository});

  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  late StateQueryExecutor stateQueryExecutor = StateQueryExecutor.fromStatesX(
    statesX: repository.stateByIdX
        .mapWithValue((stateById) => stateById.values.map((state) => statePersister.inflate(state)).toList()),
    dropContext: repository.context.dropCoreComponent,
  );

  @override
  Future<T> onExecuteQuery<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) async {
    final isNewlyRunQuery = repository.queriesRun.add(queryRequest);
    final needsSource = QueryRequestModifier.findIsWithoutCache(queryRequest) || isNewlyRunQuery;

    final loadingCompleter = completerByLoadingQueryRequest[queryRequest];
    if (loadingCompleter != null) {
      return await loadingCompleter.future;
    }

    if (needsSource) {
      return await fetchSourceAndDeleteStale(queryRequest);
    }

    return await stateQueryExecutor.executeQuery(queryRequest);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    final isNewlyRunQuery = repository.queriesRun.add(queryRequest);

    if (QueryRequestModifier.findIsWithoutCache(queryRequest)) {
      return repository.repository.executeQueryX(queryRequest);
    }

    return [
      repository.stateByIdX,
      _completerByLoadingQueryRequestX,
    ].combineLatestWithValue((values) => values).asyncMapWithValue(
      (stateById) async {
        if (completerByLoadingQueryRequest[queryRequest] != null) {
          return FutureValue.loading();
        }

        return FutureValue.loaded(await executeQuery(queryRequest));
      },
      initialValue: getInitialValue(
        queryRequest: queryRequest,
        isNewlyRunQuery: isNewlyRunQuery,
      ),
    );
  }

  FutureValue<T> getInitialValue<T>({
    required QueryRequest<dynamic, T> queryRequest,
    required bool isNewlyRunQuery,
  }) {
    if (isNewlyRunQuery) {
      fetchSourceAndDeleteStale(queryRequest);
      return FutureValue.loading();
    }

    return stateQueryExecutor.executeQueryX(queryRequest).value;
  }

  Future<T> fetchSourceAndDeleteStale<T>(QueryRequest<dynamic, T> queryRequest) async {
    final completer = Completer();
    _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..set(queryRequest, completer);

    final cachedStateIds = (await stateQueryExecutor.getFetchedStates(queryRequest)).map((state) => state.id!);

    final sourceStateIds = <String>[];
    final result = await repository.repository.executeQuery(
      queryRequest,
      onStateRetreived: (state) => sourceStateIds.add(state.id!),
    );

    for (final cachedStateId in cachedStateIds) {
      if (!sourceStateIds.contains(cachedStateId)) {
        repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(cachedStateId);
      }
    }

    completer.complete(result);
    _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..remove(queryRequest);

    return result;
  }
}

class MemoryCacheRepositoryStateHandler with IsRepositoryStateHandler {
  final MemoryCacheRepository repository;

  MemoryCacheRepositoryStateHandler({required this.repository});

  @override
  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    state = await repository.repository.update(state);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, statePersister.persist(state));
    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    state = await repository.repository.delete(state);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);
    return state;
  }
}

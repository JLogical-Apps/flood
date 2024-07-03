import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
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
      onStateRetrieved: (state) {
        if (stateByIdX.value[state.id!] != state) {
          stateByIdX.value = stateByIdX.value.copy()..set(state.id!, state);
        }
      },
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
  late final MemoryCacheRepositoryQueryExecutor queryExecutor = MemoryCacheRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = MemoryCacheRepositoryStateHandler(repository: this);
}

class MemoryCacheRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final MemoryCacheRepository repository;

  final BehaviorSubject<Map<QueryRequest, Completer>> _completerByLoadingQueryRequestX = BehaviorSubject.seeded({});

  Map<QueryRequest, Completer> get completerByLoadingQueryRequest => _completerByLoadingQueryRequestX.value;

  MemoryCacheRepositoryQueryExecutor({required this.repository});

  final Map<QueryRequest, PaginatedQueryResult?> paginatedQueryResultByQueryRequest = {};

  late final StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  late StateQueryExecutor stateQueryExecutor = StateQueryExecutor.fromStatesX(
    statesX: repository.stateByIdX
        .mapWithValue((stateById) => stateById.values.map((state) => statePersister.inflate(state)).toList()),
    dropContext: repository.context.dropCoreComponent,
  );

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
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

    if (paginatedQueryResultByQueryRequest.containsKey(queryRequest)) {
      var existingPaginatedQueryResult = paginatedQueryResultByQueryRequest[queryRequest];
      if (existingPaginatedQueryResult == null) {
        existingPaginatedQueryResult =
            await repository.repository.executeQuery(queryRequest as QueryRequest<E, PaginatedQueryResult>);
        paginatedQueryResultByQueryRequest[queryRequest] = existingPaginatedQueryResult;
      }

      return existingPaginatedQueryResult as T;
    }

    return await stateQueryExecutor.executeQuery(queryRequest);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
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

  FutureValue<T> getInitialValue<E extends Entity, T>({
    required QueryRequest<E, T> queryRequest,
    required bool isNewlyRunQuery,
  }) {
    if (isNewlyRunQuery) {
      fetchSourceAndDeleteStale(queryRequest);
      return FutureValue.loading();
    }

    return stateQueryExecutor.executeQueryX(queryRequest).value;
  }

  void reloadPagination() {
    for (final paginatedQueryResult in paginatedQueryResultByQueryRequest.keys) {
      paginatedQueryResultByQueryRequest[paginatedQueryResult] = null;
    }
  }

  Future<T> fetchSourceAndDeleteStale<E extends Entity, T>(QueryRequest<E, T> queryRequest) async {
    final completer = Completer();
    _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..set(queryRequest, completer);

    final cachedStates = await guardAsync(() => stateQueryExecutor.getFetchedStates(queryRequest)) ?? [];
    final cachedStateIds = cachedStates.map((state) => state.id!).toList();

    final sourceStateIds = <String>[];
    final sourceResult = await repository.repository.executeQuery(
      queryRequest,
      onStateRetreived: (state) => sourceStateIds.add(state.id!),
    );

    for (final cachedStateId in cachedStateIds) {
      if (!sourceStateIds.contains(cachedStateId)) {
        repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(cachedStateId);
      }
    }

    if (sourceResult is PaginatedQueryResult) {
      paginatedQueryResultByQueryRequest[queryRequest] = sourceResult;
    }

    completer.complete(sourceResult);
    _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..remove(queryRequest);

    return sourceResult;
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

    repository.queryExecutor.reloadPagination();
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, statePersister.persist(state));

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    state = await repository.repository.delete(state);

    repository.queryExecutor.reloadPagination();
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);

    return state;
  }
}

import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/request/meta/query_request_modifier.dart';
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
          stateHandler.updateCachedState(state);
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
  late final MemoryCacheRepositoryStateHandler stateHandler = MemoryCacheRepositoryStateHandler(repository: this);
}

class MemoryCacheRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final MemoryCacheRepository repository;

  final BehaviorSubject<Map<QueryRequest, Completer>> _completerByLoadingQueryRequestX = BehaviorSubject.seeded({});

  Map<QueryRequest, Completer> get completerByLoadingQueryRequest => _completerByLoadingQueryRequestX.value;

  MemoryCacheRepositoryQueryExecutor({required this.repository});

  final Map<QueryRequest, dynamic> cachedQueryRequestResults = {};
  final Map<QueryRequest, PaginatedQueryResult> paginationQueryRequestResults = {};

  late final StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  late StateQueryExecutor stateQueryExecutor = StateQueryExecutor.fromStatesX(
    statesX: repository.stateByIdX.mapWithValue((stateById) => stateById.values.toList()),
    dropContext: repository.context.dropCoreComponent,
  );

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) async {
    final loadingCompleter = completerByLoadingQueryRequest[queryRequest];
    if (loadingCompleter != null) {
      return await loadingCompleter.future;
    }

    if (needsSource(queryRequest)) {
      final source = await fetchSourceAndDeleteStale(queryRequest);
      repository.queriesRun.add(queryRequest);
      return source;
    }

    if (cachedQueryRequestResults.containsKey(queryRequest)) {
      return cachedQueryRequestResults[queryRequest];
    } else if (paginationQueryRequestResults.containsKey(queryRequest)) {
      return paginationQueryRequestResults[queryRequest] as T;
    }

    var result = await stateQueryExecutor.executeQuery(queryRequest);

    if (result is PaginatedQueryResult) {
      result = await repository.repository.executeQuery(queryRequest);
      paginationQueryRequestResults[queryRequest] = result as PaginatedQueryResult;
    } else {
      cachedQueryRequestResults[queryRequest] = result;
    }

    return result;
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    final isNewlyRunQuery = !repository.queriesRun.contains(queryRequest);

    if (QueryRequestMetaModifier.findIsWithoutCache(queryRequest)) {
      return repository.repository.executeQueryX(queryRequest);
    }

    return repository.stateByIdX.asyncMapWithValue(
      (stateById) async {
        try {
          return FutureValue.loaded(await executeQuery(queryRequest));
        } catch (error, stackTrace) {
          return FutureValue.error(error, stackTrace);
        }
      },
      initialValue: getInitialValue(
        queryRequest: queryRequest,
        isNewlyRunQuery: isNewlyRunQuery,
      ),
    );
  }

  bool needsSource(QueryRequest queryRequest) {
    final isNewlyRunQuery = !repository.queriesRun.contains(queryRequest);
    if (QueryRequestMetaModifier.findIsWithoutCache(queryRequest) || isNewlyRunQuery) {
      final singleDocumentId = QueryRequestMetaModifier.findSingleDocumentId(queryRequest);
      final hasSingleDocument = singleDocumentId != null && repository.stateByIdX.value[singleDocumentId] != null;
      return !hasSingleDocument;
    }

    return false;
  }

  FutureValue<T> getInitialValue<E extends Entity, T>({
    required QueryRequest<E, T> queryRequest,
    required bool isNewlyRunQuery,
  }) {
    if (isNewlyRunQuery) {
      return FutureValue.loading();
    }

    return stateQueryExecutor.executeQueryX(queryRequest).value;
  }

  Future<T> fetchSourceAndDeleteStale<E extends Entity, T>(QueryRequest<E, T> queryRequest) async {
    final completer = Completer();
    _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..set(queryRequest, completer);

    final cachedStates = await guardAsync(() => stateQueryExecutor.getFetchedStates(queryRequest)) ?? [];
    final cachedStateIds = cachedStates.map((state) => state.id!).toList();

    final sourceStateIds = <String>[];
    try {
      final sourceResult = await repository.repository.executeQuery(
        queryRequest,
        onStateRetreived: (state) => sourceStateIds.add(state.id!),
      );

      for (final cachedStateId in cachedStateIds) {
        if (!sourceStateIds.contains(cachedStateId)) {
          repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(cachedStateId);
        }
      }

      completer.complete(sourceResult);
      _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..remove(queryRequest);

      return sourceResult;
    } catch (e) {
      completer.completeError(e);
      _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..remove(queryRequest);

      rethrow;
    }
  }
}

class MemoryCacheRepositoryStateHandler with IsRepositoryStateHandler {
  final MemoryCacheRepository repository;

  MemoryCacheRepositoryStateHandler({required this.repository});

  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    state = await repository.repository.update(state);
    repository.queryExecutor.paginationQueryRequestResults.clear();
    updateCachedState(state);
    return state;
  }

  void updateCachedState(State state) {
    repository.queryExecutor.cachedQueryRequestResults.clear();
    final cachedState = statePersister.inflate(statePersister.persist(state));
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, cachedState);
  }

  @override
  Future<State> onDelete(State state) async {
    state = await repository.repository.delete(state);

    repository.queryExecutor.cachedQueryRequestResults.clear();
    repository.queryExecutor.paginationQueryRequestResults.clear();
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);

    return state;
  }
}

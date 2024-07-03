import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

const _defaultTimeoutSeconds = 2;
const forceSourceUpdateField = 'forceSourceUpdate';

class DeviceSyncCacheRepository with IsRepositoryWrapper {
  @override
  late final Repository repository;

  final Duration timeout;

  final BehaviorSubject<Map<String, State>> stateByIdX = BehaviorSubject.seeded({});
  final Set<QueryRequest> queriesRun = {};

  late final Repository cacheRepository;
  late Set<String> cachedQueryRequests;

  DeviceSyncCacheRepository({
    required Repository sourceRepository,
    this.timeout = const Duration(seconds: _defaultTimeoutSeconds),
  }) {
    repository = sourceRepository.withListener(onStateRetrieved: (state) => cacheRepository.update(state));
    cacheRepository = Repository.forAny()
        .file('deviceRepositoryCache/${RepositoryMetaModifier.getModifier(repository).getPath(repository)}')
        .withListener(onStateRetrieved: (state) {
      return stateByIdX.value = stateByIdX.value.copy()..set(state.id!, state);
    });
  }

  DataSource<String> getCachedQueryRequestsDataSource(CorePondContext context) {
    return DataSource.static.crossFile(context.fileSystem.storageDirectory - 'cachedQueryRequests.txt');
  }

  @override
  late final List<CorePondComponentBehavior> behaviors = super.behaviors +
      [
        CorePondComponentBehavior(
          onRegister: (context, _) async {
            cacheRepository.context = context;

            final rawCachedQueryRequests = await getCachedQueryRequestsDataSource(context).getOrNull() ?? '';
            cachedQueryRequests = rawCachedQueryRequests.split('\n').toSet();
          },
          onReset: (context, _) async {
            stateByIdX.value = {};
            queriesRun.clear();
            await getCachedQueryRequestsDataSource(context).delete();
            cachedQueryRequests = {};
            await cacheRepository.reset(context);
          },
        ),
      ];

  @override
  late final DeviceCacheRepositoryQueryExecutor queryExecutor = DeviceCacheRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = DeviceCacheRepositoryStateHandler(repository: this);

  Future<void> updateCachedQueryRequests(QueryRequest queryRequest) async {
    final prettyPrinted = queryRequest.prettyPrint(repository.context.dropCoreComponent);
    if (cachedQueryRequests.add(prettyPrinted)) {
      await getCachedQueryRequestsDataSource(repository.context).set(cachedQueryRequests.join('\n'));
    }
  }
}

class DeviceCacheRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final DeviceSyncCacheRepository repository;

  final BehaviorSubject<Map<QueryRequest, Completer>> _completerByLoadingQueryRequestX = BehaviorSubject.seeded({});

  Map<QueryRequest, Completer> get completerByLoadingQueryRequest => _completerByLoadingQueryRequestX.value;

  DeviceCacheRepositoryQueryExecutor({required this.repository});

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
    final loadingCompleter = completerByLoadingQueryRequest[queryRequest];
    if (loadingCompleter != null) {
      return await loadingCompleter.future;
    }

    final isNewlyRunLocalQuery = repository.queriesRun.add(queryRequest);
    final isNewlyRunDeviceQuery =
        !repository.cachedQueryRequests.contains(queryRequest.prettyPrint(repository.context.dropCoreComponent));
    final needsSource =
        QueryRequestModifier.findIsWithoutCache(queryRequest) || (isNewlyRunLocalQuery && isNewlyRunDeviceQuery);

    if (needsSource) {
      final result = await fetchSourceAndDeleteStale(queryRequest);
      await repository.updateCachedQueryRequests(queryRequest);
      return result;
    } else if (isNewlyRunLocalQuery) {
      final result = await repository.cacheRepository.executeQuery(queryRequest);
      if (result is! PaginatedQueryResult) {
        return result;
      }
    }

    if (paginatedQueryResultByQueryRequest.containsKey(queryRequest)) {
      var existingPaginatedQueryResult = paginatedQueryResultByQueryRequest[queryRequest];
      if (existingPaginatedQueryResult != null) {
        return existingPaginatedQueryResult as T;
      }

      existingPaginatedQueryResult =
          await repository.repository.executeQuery(queryRequest as QueryRequest<E, PaginatedQueryResult>);
      final mappedPaginatedQueryResult =
          await fromSourcePaginatedQueryResult(queryRequest, existingPaginatedQueryResult!);
      paginatedQueryResultByQueryRequest[queryRequest] = mappedPaginatedQueryResult;
      return mappedPaginatedQueryResult as T;
    }

    return await stateQueryExecutor.executeQuery(queryRequest);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    if (QueryRequestModifier.findIsWithoutCache(queryRequest)) {
      return repository.repository.executeQueryX(queryRequest);
    }

    final isNewlyRunLocalQuery = repository.queriesRun.add(queryRequest);
    final isNewlyRunDeviceQuery =
        !repository.cachedQueryRequests.contains(queryRequest.prettyPrint(repository.context.dropCoreComponent));

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
        isNewlyRunLocalQuery: isNewlyRunLocalQuery,
        isNewlyRunDeviceQuery: isNewlyRunDeviceQuery,
      ),
    );
  }

  FutureValue<T> getInitialValue<E extends Entity, T>({
    required QueryRequest<E, T> queryRequest,
    required bool isNewlyRunLocalQuery,
    required bool isNewlyRunDeviceQuery,
  }) {
    if (isNewlyRunDeviceQuery) {
      () async {
        await fetchSourceAndDeleteStale(queryRequest);
        await repository.updateCachedQueryRequests(queryRequest);
      }();
      return FutureValue.loading();
    }

    if (isNewlyRunLocalQuery) {
      () async {
        try {
          await fetchSourceAndDeleteStale(queryRequest);
        } catch (e) {
          await repository.cacheRepository.executeQuery(queryRequest);
        }
      }();
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

    try {
      final localCachedStates = await guardAsync(() => stateQueryExecutor.getFetchedStates(queryRequest)) ?? [];
      final deviceCachedStates =
          await guardAsync(() => repository.cacheRepository.getFetchedStates(queryRequest)) ?? [];

      final sourceStateIds = <String>[];
      final sourceResult = await repository.repository
          .executeQuery(
            queryRequest,
            onStateRetreived: (state) => sourceStateIds.add(state.id!),
          )
          .timeout(repository.timeout);

      for (final cachedState in localCachedStates) {
        if (!sourceStateIds.contains(cachedState.id)) {
          repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(cachedState.id);
        }
      }

      for (final cachedState in deviceCachedStates) {
        if (!sourceStateIds.contains(cachedState.id)) {
          repository.cacheRepository.delete(cachedState);
        }
      }

      if (sourceResult is PaginatedQueryResult) {
        final mappedPaginatedQueryResult = await fromSourcePaginatedQueryResult(queryRequest, sourceResult);
        paginatedQueryResultByQueryRequest[queryRequest] = mappedPaginatedQueryResult;
        completer.complete(mappedPaginatedQueryResult);
        return mappedPaginatedQueryResult as T;
      }

      completer.complete(sourceResult);
      return sourceResult;
    } catch (e, stackTrace) {
      completer.completeError(e, stackTrace);
      rethrow;
    } finally {
      _completerByLoadingQueryRequestX.value = completerByLoadingQueryRequest.copy()..remove(queryRequest);
    }
  }

  Future<PaginatedQueryResult> fromSourcePaginatedQueryResult(
    QueryRequest queryRequest,
    PaginatedQueryResult sourceResult,
  ) async {
    final cachedPaginatedQueryResult =
        await repository.cacheRepository.executeQuery(queryRequest) as PaginatedQueryResult;
    return cachedPaginatedQueryResult.withListener(onLoaded: (_) => sourceResult.getNextPageOrNull());
  }
}

class DeviceCacheRepositoryStateHandler with IsRepositoryStateHandler {
  final DeviceSyncCacheRepository repository;

  DeviceCacheRepositoryStateHandler({required this.repository});

  @override
  late StatePersister<State> statePersister = StatePersister.state(context: repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    if (state.metadata[forceSourceUpdateField] == true) {
      return await repository.repository.update(state);
    } else {
      await repository.context.syncCoreComponent
          .registerAction(UpdateEntitySyncActionEntity()..set(UpdateEntitySyncAction()..stateProperty.set(state)));
    }

    repository.queryExecutor.reloadPagination();

    await repository.cacheRepository.update(state);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, statePersister.persist(state));

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    if (state.metadata[forceSourceUpdateField] == true) {
      return await repository.repository.delete(state);
    } else {
      await repository.context.syncCoreComponent
          .registerAction(DeleteEntitySyncActionEntity()..set(DeleteEntitySyncAction()..stateProperty.set(state)));
    }

    repository.queryExecutor.reloadPagination();

    await repository.cacheRepository.delete(state);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);

    return state;
  }
}

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/request/meta/query_request_modifier.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

const _defaultTimeoutSeconds = 2;
const forceSourceUpdateField = '_forceSourceUpdate';

class DeviceSyncCacheRepository with IsRepositoryWrapper {
  static const cacheRootFolder = 'deviceRepositoryCache';

  late final Repository sourceRepository;
  late final Repository cacheRepository;
  late final String repositoryPath;

  final Duration timeout;

  late Set<String> cachedQueryRequests;

  DeviceSyncCacheRepository({
    required Repository sourceRepository,
    this.timeout = const Duration(seconds: _defaultTimeoutSeconds),
  }) {
    repositoryPath = RepositoryMetaModifier.getModifier(sourceRepository).getPath(sourceRepository)!;
    cacheRepository = Repository.forAny().file('$cacheRootFolder/$repositoryPath');
    this.sourceRepository = sourceRepository.withListener(onStateRetrieved: (state) async {
      final syncEntities = await context.syncCoreComponent.getSyncEntities();
      if (syncEntities.none((entity) => entity.value.modifies(state))) {
        await cacheRepository.update(state);
      }
    });
  }

  @override
  Repository get repository => sourceRepository;

  DataSource<String> getCachedQueryRequestsDataSource(CorePondContext context) {
    return DataSource.static
        .crossFile(context.fileSystem.storageDirectory / cacheRootFolder / 'cachedQueries' - '$repositoryPath.txt');
  }

  @override
  late final List<CorePondComponentBehavior> behaviors = super.behaviors +
      [
        CorePondComponentBehavior(
          onRegister: (context, _) async {
            await cacheRepository.registerTo(context);

            final rawCachedQueryRequests = await getCachedQueryRequestsDataSource(context).getOrNull() ?? '';
            cachedQueryRequests = rawCachedQueryRequests.split('\n').toSet();
          },
          onReset: (context, _) async {
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

  final Map<QueryRequest, PaginatedQueryResult?> paginatedQueryResultByQueryRequest = {};

  DeviceCacheRepositoryQueryExecutor({required this.repository});

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) async {
    final needsSource = await this.needsSource<E>(queryRequest);
    if (needsSource) {
      final result = await fetchSourceAndDeleteStale(queryRequest, onStateRetreived: onStateRetreived);
      await repository.updateCachedQueryRequests(queryRequest);
      return result;
    }

    final result = await repository.cacheRepository.executeQuery(queryRequest, onStateRetreived: onStateRetreived);

    if (result is PaginatedQueryResult) {
      var existingPaginatedQueryResult = paginatedQueryResultByQueryRequest[queryRequest];
      if (existingPaginatedQueryResult == null) {
        existingPaginatedQueryResult = await mapPaginationRequest(queryRequest: queryRequest, result: result);
        paginatedQueryResultByQueryRequest[queryRequest] = existingPaginatedQueryResult;
      }

      return existingPaginatedQueryResult as T;
    } else if (!needsSource) {
      fetchSourceAndDeleteStale(queryRequest, onStateRetreived: onStateRetreived);
    }

    return result;
  }

  void reloadPagination() {
    for (final paginatedQueryResult in paginatedQueryResultByQueryRequest.keys) {
      paginatedQueryResultByQueryRequest[paginatedQueryResult] = null;
    }
  }

  Future<bool> needsSource<E extends Entity>(QueryRequest queryRequest) async {
    final isNewlyRunQuery =
        !repository.cachedQueryRequests.contains(queryRequest.prettyPrint(repository.context.dropCoreComponent));
    if (QueryRequestMetaModifier.findIsWithoutCache(queryRequest) || isNewlyRunQuery) {
      final singleDocumentId = QueryRequestMetaModifier.findSingleDocumentId(queryRequest);
      if (singleDocumentId == null) {
        return true;
      }

      final cachedEntity = await repository.cacheRepository.executeQuery(Query.getByIdOrNull<E>(singleDocumentId));
      return cachedEntity == null;
    }

    return false;
  }

  Future<T> mapPaginationRequest<T>({required QueryRequest queryRequest, required PaginatedQueryResult result}) async {
    PaginatedQueryResult? sourcePaginatedQueryResult;
    () async {
      sourcePaginatedQueryResult ??= await guardAsync(
          () async => await repository.sourceRepository.executeQuery(queryRequest) as PaginatedQueryResult);
      await sourcePaginatedQueryResult?.getNextPageOrNull();
    }();
    return result.withListener((page) {
      () async {
        await sourcePaginatedQueryResult?.getNextPageOrNull();
      }();
    }) as T;
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    if (QueryRequestMetaModifier.findIsWithoutCache(queryRequest)) {
      return repository.sourceRepository.executeQueryX(queryRequest);
    }

    final isNewlyRunQuery =
        !repository.cachedQueryRequests.contains(queryRequest.prettyPrint(repository.context.dropCoreComponent));
    if (isNewlyRunQuery) {
      () async {
        await fetchSourceAndDeleteStale(queryRequest);
        await repository.updateCachedQueryRequests(queryRequest);
      }();
    }

    return repository.cacheRepository.executeQueryX(queryRequest, onStateRetreived: onStateRetreived);
  }

  Future<T> fetchSourceAndDeleteStale<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) async {
    final cachedStates = await guardAsync(() => repository.cacheRepository.getFetchedStates(queryRequest)) ?? [];

    final sourceStates = <State>[];
    final sourceResult = await repository.sourceRepository
        .executeQuery(queryRequest, onStateRetreived: (state) => sourceStates.add(state))
        .timeout(repository.timeout);

    final syncEntities = await repository.context.syncCoreComponent.getSyncEntities();
    for (final syncEntity in syncEntities) {
      syncEntity.value.modifyStates(sourceStates);
    }

    final sourceStateIds = sourceStates.map((state) => state.id!).toSet();

    for (final cachedState in cachedStates) {
      if (!sourceStateIds.contains(cachedState.id)) {
        repository.cacheRepository.delete(cachedState);
      }
    }

    if (sourceResult is PaginatedQueryResult) {
      paginatedQueryResultByQueryRequest[queryRequest] = sourceResult;
    }

    for (final state in sourceStates) {
      await onStateRetreived?.call(state);
    }

    return sourceResult;
  }
}

class DeviceCacheRepositoryStateHandler with IsRepositoryStateHandler {
  final DeviceSyncCacheRepository repository;

  DeviceCacheRepositoryStateHandler({required this.repository});

  @override
  Future<State> onUpdate(State state) async {
    if (state.metadata[forceSourceUpdateField] == true) {
      return await repository.sourceRepository.update(state);
    } else {
      await repository.context.syncCoreComponent
          .registerAction(UpdateEntitySyncActionEntity()..set(UpdateEntitySyncAction()..stateProperty.set(state)));

      state = await repository.cacheRepository.update(state);
      repository.queryExecutor.reloadPagination();
      return state;
    }
  }

  @override
  Future<State> onDelete(State state) async {
    if (state.metadata[forceSourceUpdateField] == true) {
      return await repository.sourceRepository.delete(state);
    } else {
      await repository.context.syncCoreComponent
          .registerAction(DeleteEntitySyncActionEntity()..set(DeleteEntitySyncAction()..stateProperty.set(state)));

      state = await repository.cacheRepository.delete(state);
      repository.queryExecutor.reloadPagination();
      return state;
    }
  }
}

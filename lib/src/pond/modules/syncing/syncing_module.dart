import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/sync_publish_actions_repository.dart';
import 'package:pool/pool.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import 'local_sync_publish_actions_repository.dart';
import 'publish_actions/delete_sync_publish_action.dart';
import 'publish_actions/delete_sync_publish_action_entity.dart';
import 'publish_actions/save_sync_publish_action.dart';
import 'publish_actions/save_sync_publish_action_entity.dart';

class SyncingModule extends AppModule {
  /// The repository to save the SyncPublishActionEntities.
  final EntityRepository syncPublishActionsRepository;

  /// Whether the syncing module is disabled, so no syncing will occur.
  final bool isDisabled;

  late final BehaviorSubject<FutureValue<void>> _syncingStatusX =
      BehaviorSubject.seeded(isDisabled ? FutureValue.error(error: 'Syncing is disabled.') : FutureValue.initial());
  late final ValueStream<FutureValue<void>> syncingStatusX = _syncingStatusX;

  SyncingModule({EntityRepository? syncPublishActionsRepository, this.isDisabled: false})
      : this.syncPublishActionsRepository = syncPublishActionsRepository ??
            (kIsWeb ? LocalSyncPublishActionsRepository() : SyncPublishActionsRepository());

  SyncingModule.testing({this.isDisabled: false}) : syncPublishActionsRepository = LocalSyncPublishActionsRepository();

  final List<SyncDownloadAction> _downloadActions = [];
  final Queue<SyncPublishActionEntity> _publishActionEntitiesQueue = Queue();
  final Pool _pool = Pool(10, timeout: Duration(seconds: 30));

  @override
  void onRegister(AppRegistration registration) {
    registration.register(syncPublishActionsRepository);
  }

  @override
  Future<void> onLoad(AppContext appContext) async {
    if (isDisabled) {
      return;
    }

    _syncingStatusX.value = FutureValue.initial();
    await _loadPendingPublishActions();
    await reload();
  }

  /// Register a scope to download when [download] is called.
  void registerQueryDownload(FutureOr<QueryRequest?> queryRequestGetter()) {
    _downloadActions.add(QuerySyncDownloadAction(() async {
      final queryRequest = await queryRequestGetter();
      return [if (queryRequest != null) queryRequest];
    }));
  }

  /// Register a scope to download when [download] is called.
  void registerQueryDownloads(FutureOr<List<QueryRequest>> queryRequestGetter()) {
    _downloadActions.add(QuerySyncDownloadAction(queryRequestGetter));
  }

  void registerDownload(SyncDownloadAction syncDownloadAction) {
    _downloadActions.add(syncDownloadAction);
  }

  static final _publishLock = Lock();

  Future<void> reload() async {
    if (isDisabled) {
      return;
    }
    await publish();
    await download();
  }

  /// Publish all pending changes to source repositories.
  Future<void> publish() async {
    if (isDisabled) {
      return;
    }
    try {
      // No need to re-publish if publishing is happening currently.
      if (_publishLock.locked) {
        return;
      }

      await _publishLock.synchronized(() async {
        _syncingStatusX.value = FutureValue.initial();
        while (_publishActionEntitiesQueue.isNotEmpty) {
          final actionEntity = _publishActionEntitiesQueue.first;
          await actionEntity.value.publish();

          _publishActionEntitiesQueue.removeFirst();
          await actionEntity.delete();
        }
        _syncingStatusX.value = FutureValue.loaded(value: null);
      });
    } catch (e) {
      _syncingStatusX.value = FutureValue.error(error: e);
      rethrow;
    }
  }

  Future<void> download() async {
    if (isDisabled) {
      return;
    }
    try {
      _syncingStatusX.value = FutureValue.initial();
      await _downloadHighPriorityDownloads();
      () async {
        try {
          await _downloadLowPriorityDownloads();
          _syncingStatusX.value = FutureValue.loaded(value: null);
        } catch (e) {
          _syncingStatusX.value = FutureValue.error(error: e);
          rethrow;
        }
      }();
    } catch (e) {
      _syncingStatusX.value = FutureValue.error(error: e);
      rethrow;
    }
  }

  Future<void> _downloadHighPriorityDownloads() async {
    await Future.wait(_downloadActions
        .where((download) => download.priority == SyncDownloadPriority.high)
        .map((download) => _pool.withResource(download.download)));
  }

  Future<void> _downloadLowPriorityDownloads() async {
    await Future.wait(_downloadActions
        .where((download) => download.priority == SyncDownloadPriority.low)
        .map((download) => _pool.withResource(download.download)));
  }

  Future<void> deleteLocalChanges() async {
    for (final publishAction in _publishActionEntitiesQueue) {
      await publishAction.delete();
    }

    _publishActionEntitiesQueue.clear();

    await download();
  }

  Future<void> enqueueSave(State state) {
    return enqueueSyncPublishAction(SaveSyncPublishActionEntity()..value = SaveSyncPublishAction.fromSaveState(state));
  }

  Future<void> enqueueDelete(State state) {
    return enqueueSyncPublishAction(
        DeleteSyncPublishActionEntity()..value = DeleteSyncPublishAction.fromDeleteState(state));
  }

  Future<void> enqueueSyncPublishAction(SyncPublishActionEntity action) async {
    _publishActionEntitiesQueue.add(action);
    await action.create();
  }

  Future<T> executeQueryOnSource<R extends Record, T>(QueryRequest<R, T> queryRequest) async {
    final sourceRepository = getSourceRepositoryRuntime(queryRequest.query.recordType);
    final result = await sourceRepository.executeQuery(queryRequest);
    return result;
  }

  EntityRepository? getSourceRepositoryRuntimeOrNull(Type entityType) {
    final syncingRepository = AppContext.global.appModules
        .whereType<SyncingRepository>()
        .firstWhereOrNull((repository) => repository.sourceRepository.handledEntityTypes.contains(entityType));
    if (syncingRepository == null) {
      return null;
    }

    return syncingRepository.sourceRepository;
  }

  EntityRepository getSourceRepositoryRuntime(Type entityType) {
    return getSourceRepositoryRuntimeOrNull(entityType) ??
        (throw Exception('Unable to find source repository for entity [$entityType]'));
  }

  EntityRepository? getSourceRepositoryOrNull<E extends Entity>() {
    return getSourceRepositoryRuntimeOrNull(E);
  }

  EntityRepository getSourceRepository<E extends Entity>() {
    return getSourceRepositoryRuntimeOrNull(E) ?? (throw Exception('Unable to find source repository for entity [$E]'));
  }

  EntityRepository? getSourceRepositoryByStateOrNull(State state) {
    final typeName = state.type;
    if (typeName == null) {
      return null;
    }

    final stateType = AppContext.global.getTypeByName(typeName);

    final syncingRepository = AppContext.global.appModules
        .whereType<SyncingRepository>()
        .firstWhereOrNull((repository) => repository.sourceRepository.handledEntityTypes.contains(stateType));
    if (syncingRepository == null) {
      return null;
    }

    return syncingRepository.sourceRepository;
  }

  EntityRepository getSourceRepositoryByState(State state) {
    return getSourceRepositoryByStateOrNull(state) ??
        (throw Exception('Unable to find source repository for state [$state]'));
  }

  Future<void> _loadPendingPublishActions() async {
    final pendingPublishActionEntities =
        await Query.from<SyncPublishActionEntity>().orderByAscending(ValueObject.timeCreatedField).all().get();
    _publishActionEntitiesQueue.addAll(pendingPublishActionEntities);
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/sync_publish_action_entity.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/sync_publish_actions_repository.dart';

import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../../query/query.dart';
import '../../query/request/query_request.dart';
import '../../record/entity.dart';
import '../../record/value_object.dart';
import '../../repository/entity_repository.dart';
import '../../state/state.dart';
import '../logging/default_logging_module.dart';
import 'publish_actions/delete_sync_publish_action.dart';
import 'publish_actions/delete_sync_publish_action_entity.dart';
import 'publish_actions/save_sync_publish_action.dart';
import 'publish_actions/save_sync_publish_action_entity.dart';
import 'sync_download_action.dart';
import 'syncing_repository.dart';

class SyncingModule extends AppModule {
  final List<SyncDownloadAction> _downloadActions = [];
  final Queue<SyncPublishActionEntity> _publishActionEntitiesQueue = Queue();

  @override
  void onRegister(AppRegistration registration) {
    registration.register(SyncPublishActionsRepository());
  }

  @override
  Future<void> onLoad(AppContext appContext) async {
    await _loadPendingPublishActions();
  }

  /// Register a scope to download when [download] is called.
  void registerQueryDownload(QueryRequest queryRequestGetter()) {
    _downloadActions.add(QuerySyncDownloadAction(queryRequestGetter));
  }

  /// Publish all pending changes to source repositories.
  Future<void> publish() async {
    try {
      while (_publishActionEntitiesQueue.isNotEmpty) {
        final actionEntity = _publishActionEntitiesQueue.first;
        await actionEntity.value.publish();

        _publishActionEntitiesQueue.removeFirst();
        await actionEntity.delete();
      }
    } catch (e) {
      logError(e);
    }
  }

  Future<void> download() async {
    await Future.wait(_downloadActions.map((action) => action.download()));
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
